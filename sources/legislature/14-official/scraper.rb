#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class Legislature
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      alternate_active? ? alternate_name : current
    end

    field :alternate do
      alternate_active? ? current : alternate_name
    end

    field :constituency do
      noko.css('.team-member-job-title').text.gsub('Député de ', '').tidy
    end

    field :party do
      description[1].split(/:/).last.tidy
    end

    def current
      noko.css('.team-member-name').text.tidy
    end

    def description
      noko.css('.team-member-description text()').map(&:text).map(&:tidy)
    end

    def alternaterole
      description[0].split(/:/).first.tidy
    end

    def alternate_active?
      alternaterole == 'Titulaire'
    end

    def alternate_name
      description[0].split(/:/)[1].to_s.tidy
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      noko.css('.content .avia-team-member').map { |mp| fragment(mp => Member) }.map(&:to_h)
    end
  end
end

file = Pathname.new 'scraped.html'
puts EveryPoliticianScraper::FileData.new(file, klass: Legislature::Members).csv

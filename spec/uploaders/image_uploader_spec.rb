# frozen_string_literal: true

require 'spec_helper'
require 'carrierwave/test/matchers'

RSpec.describe ImageUploader do
  include CarrierWave::Test::Matchers

  let(:picture) { Fabricate(:picture) }
  let(:jpg_picture) { File.open('spec/support/files/test.jpg') }
  let(:picture_1280) { File.open('spec/support/files/test-1280.jpg') }
  let(:uploader) { described_class.new(picture) }

  # Enable images processing before executing the examples
  before(:all) do
    ImageUploader.enable_processing = true
  end

  # Disable images processing after executing the examples
  after(:all) do
    ImageUploader.enable_processing = false
  end

  context 'default version' do
    it 'scales down an image to be no larger than 800x800 pixels' do
      uploader.store!(picture_1280)

      expect(uploader).to be_no_larger_than(800, 800)
    end
  end

  context 'thumb version' do
    it 'scales down an image to be exactly 64 by 64 pixels' do
      uploader.store!(jpg_picture)

      expect(uploader.thumb).to have_dimensions(100, 100)
    end
  end

  context 'whitelist extensions' do
    let(:whitelist) { %i[gif png] }
    it 'raises an error for files with invalid extension' do
      allow(uploader).to receive(:extension_whitelist).and_return(whitelist)

      expect { uploader.store!(jpg_picture) }.
        to raise_error(/You are not allowed to upload "jpg" files, allowed types: gif, png/)
    end
  end

  context 'size_range' do
    it 'raises an error for files bigger than the max size' do
      allow(uploader).to receive(:size_range).and_return(0..1)

      expect { uploader.store!(jpg_picture) }.
        to raise_error(/File size should be less than 1 Byte/)
    end
  end
end

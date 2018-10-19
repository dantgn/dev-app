# frozen_string_literal: true

Fabricator(:picture) do
  user { Fabricate(:user) }
  image do
    File.open(File.join(Rails.root, 'spec', 'support', 'files', 'test.jpg'))
  end
end

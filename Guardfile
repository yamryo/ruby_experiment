# A sample Guardfile
# More info at https://github.com/guard/guard#readme
notification :off

group :rspec do
  guard 'rspec', cmd: 'bundle exec rspec' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^src/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  end
end

group :rubocop do
  guard 'rubocop' do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop(_todo)*\.yml$}) { |m| File.dirname(m[0]) }
  end
end

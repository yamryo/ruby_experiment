# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^src/(.+)\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
end

guard :rubocop do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop(_todo)*\.yml$}) { |m| File.dirname(m[0]) }
end

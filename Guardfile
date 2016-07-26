guard(
  :rspec, cmd: "bundle exec rspec", failed_mode: :keep,
  all_after_pass: false, all_on_start: true
) do
  watch %r{^spec/.+_spec\.rb$}
	watch(%r{^lib/.+\.rb$})      { 'spec' }
	watch('spec/spec_helper.rb') { 'spec' }
end

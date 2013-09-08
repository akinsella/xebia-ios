#!/usr/bin/env ruby
if ENV['SL_RUN_UNIT_TESTS'] then
    launcher_path = "ios-sim"
    test_bundle_path = File.join(ENV['BUILT_PRODUCTS_DIR'], "#{ENV['PRODUCT_NAME']}.#{ENV['WRAPPER_EXTENSION']}")

    environment = {
        'DYLD_INSERT_LIBRARIES' => "/../../Library/PrivateFrameworks/IDEBundleInjection.framework/IDEBundleInjection",
        'XCInjectBundle' => test_bundle_path,
        'XCInjectBundleInto' => ENV["TEST_HOST"]
    }

    environment_args = environment.collect { |key, value| "--setenv #{key}=\"#{value}\""}.join(" ")

    app_test_host = File.dirname(ENV["TEST_HOST"])

    puts "=== Launching: #{launcher_path} launch \"#{app_test_host}\" #{environment_args} --unit-testing --args -SenTest All #{test_bundle_path}"

    passed = system("#{launcher_path} launch \"#{app_test_host}\" #{environment_args} --unit-testing --args -SenTest All #{test_bundle_path}")

	puts "=== Return code: #{passed}"
    exit(1) if !passed
else
    puts "=== SL_RUN_UNIT_TESTS not set - Did not run unit tests!"
end

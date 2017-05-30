Acouchi
=======

![acouchi](https://github.com/AndrewVos/acouchi/raw/master/acouchi.jpg)

Requirements
------------

* [Android SDK](http://developer.android.com/sdk/installing/index.html) (Make sure to add SDK/tools and SDK/platform-tools to your PATH)
* [apktool](http://code.google.com/p/android-apktool/)
* [ant](http://ant.apache.org/manual/install.html)
* A running Android emulator, or a plugged in Android device

The Build Process
-----------------

Acouchi needs to make some tweaks to your APK to allow functional testing. This is roughly the process:

* Temporarily add some source files, and the Robotium jar file to your project
* Build your project in debug mode with ant
* Hack the APK file and inject some need elements in your AndroidManifest.xml

Please note that the build only has to happen again if your java code for the application under test changes.

How It Works
------------

Acouchi builds Robotium and a HTTP server into your Android application. Robotium is an API that has some amazing functionality for functional testing on Android.
In the Ruby API we post method calls via HTTP to the server on your device, which in turn returns meaningful data.

Cucumber
--------

### PROJECT_ROOT/features/support/env.rb

```ruby
require "acouchi"
require "acouchi/cucumber"
require "acouchi/rspec/matchers"

configuration = Acouchi::Configuration.from_json(File.read("acouchi_configuration.json"))
configuration.device =ENV["ACOUCHI_DEVICE"] if ENV["ACOUCHI_DEVICE"]
configuration.port =ENV["ACOUCHI_PORT"] if ENV["ACOUCHI_PORT"]

Acouchi::Cucumber.prepare(configuration)

def page
  Acouchi::Cucumber.page
end
```

### PROJECT_ROOT/acouchi_configuration.json

```ruby
    {
      "target_package": "com.acouchi.sample",
      "activity"      : "com.acouchi.sample.StartupActivity",
      "project_path"  : ".",
      "apk"           : "AcouchiSample-debug.apk"
    }
```

### PROJECT_ROOT/Rakefile

```ruby
    require "acouchi/rake/tasks
```

Running the tests
-----------------

```
rake build #only if you modify the application code
cucumber
```

Pressing Keys
-------------

```ruby
page.send_key Acouchi::Solo::MENU
page.send_key Acouchi::Solo::LEFT
page.send_key Acouchi::Solo::RIGHT
```

Modifying Text
--------------

```ruby
# Enter text into the only text area on the page
page.enter_text "Hello"

# This enters text into the fifth text area
page.enter_text "Hello", 5

# Clear text from the only edit text area on the page
page.clear_text

# Clear text from the fourth edit text area
page.clear_text 4
```

Searching Text
--------------

```ruby
# Check if page has_text
page.has_text? "Bla"

# has_text? default options
page.has_text?("Text", {
  :scroll          => true, # Scroll down the page searching for text
  :minimum_matches => 0,    # Zero means you don't care how many matches there are.
  :must_be_visible => true  # Whether you care if the text is visible or not.
})

# List all content currently on the page
page.content

# List all content currently on the page and scroll up and down
# to find any content which may have been missed
page.all_content
```

Clicking Things
---------------

```ruby
# Check if button with text exists
page.has_button? "Clicky"

# Click on some text
page.click_text "Hello"

# click_text default options
page.click_text("Text", {
  :match       => 1, # The match of the text that should be clicked
  :auto_scroll => true # Auto scroll to find text to click on
})

# Click on a view by id
page.click_view 123

# Click on an image by index
page.click_image 5
```

Finding Views
-------------

```ruby
# List the buttons currently on the page
page.buttons

# List the text views currently on the page
page.text_views
```

Scrolling
---------

```ruby
page.scroll_up
page.scroll_down

# Scroll up or down the only list on the page
page.scroll_up_list
page.scroll_down_list

# Scroll up or down a list by its index
page.scroll_up_list 4
page.scroll_down_list 4

# Scroll to left or right
page.scroll_to_left
page.scroll_to_right
```

Navigating
----------

```ruby
# Press the back button
page.go_back
```

Waiting
-------

Most methods in acouchi will wait for a while until an element is available.

```ruby
# Wait for the text "Bla Bla" to appear. Returns true if the text appears.
page.wait_for_text "Bla Bla"

# wait_for_text default options
page.wait_for_text "Bla Bla", {
  # The minimum amount of matches you want to appear
  :minimum_number_of_matches => 0,
  # How long to wait for, in seconds
  :timeout                   => 20,
  # Scroll the page in search of text
  :scroll                    => true,
  # Only take into account visible text
  :must_be_visible           => true
}
```

RSpec
-----

```ruby
require "acouchi/rspec/matchers"

# The have_text matcher will now output all page content
# if the assertion fails
page.should have_text "Bla"
```

Troubleshooting
---------------

### Problems clicking on buttons and text

If it seems that buttons/text aren't being clicked properly, you need to add the following xml to your AndroidManifest.xml:

```xml
<uses-sdk android:targetSdkVersion="SDK_VERSION" />
```

Where SDK_VERSION is the version of the Android SDK you are using. Version numbers can be found [here](http://developer.android.com/reference/android/os/Build.VERSION_CODES.html)

For example, Android 4.0 uses version 14, Android 4.0.3 uses version 15 and Android 4.1 uses version 16.

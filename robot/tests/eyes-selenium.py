from selenium import webdriver
from applitools.eyes import Eyes

class HelloWorld:

    eyes = Eyes()

    # Initialize the eyes SDK and set your private API key.
    eyes.api_key = 'Nml08lERP106AWuL5kUAYeU4LyV5108l8IXQPozIPnnbzSU110'

    try:

        # Open a Chrome browser.
        driver = webdriver.Chrome()

        # Start the test and set the browser's viewport size to 800x600.
        eyes.open(driver=driver, app_name='Hello World!', test_name='My first Selenium Python test!',
        viewport_size={'width': 500, 'height': 300})
        # Navigate the browser to the "hello world!" web-site.
        driver.get('https://applitools.com/helloworld')

        # Visual checkpoint #1.
        eyes.check_window('Hello!')

        # Click the 'Click me!' button.
        driver.find_element_by_css_selector('button').click()

        # Visual checkpoint #2.
        eyes.check_window('Click!')

        # End the test.
        eyes.close()

    finally:

        # Close the browser.
        driver.quit()

        # If the test was aborted before eyes.close was called, ends the test as aborted.
        eyes.abort_if_not_closed()
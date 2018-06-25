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
        eyes.open(driver=driver, app_name='Springster Demo', test_name='Springster UI test.',
        viewport_size={'width': 800, 'height': 600})
        
        # Navigate the browser to the "hello world!" web-site.
        driver.get('http://springster-example.qa-hub.ie.gehosting.org/')

        # Visual checkpoint #1. Check landing page.
        eyes.check_window('Springster Example - Sign in')

        # Click the 'Click me!' button.
        driver.find_element_by_css_selector('a.button:nth-child(4)').click()

        # Visual checkpoint #2. Check login page.
        eyes.check_window('Login')

        # Login to user profile.
        driver.enter_username
        driver.enter_password
        driver.click_login

        # Visual checkpoint #3. Check profile home page.
        eyes.check_window('Springster Example - Home page')

        # Click the 'Edit profile' button.
        driver.find_element_by_css_selector('a.button:nth-child(4)').click()

        # Visual checkpoint #4. Check edit profile page.
        eyes.check_window('Edit Your Profile')

        # Click the 'Home' link.
        driver.find_element_by_css_selector('a.button:nth-child(4)').click()

        # Goto 'Afrikaans' site:
        driver.find_element_by_css_selector('a.button:nth-child(4)').click()

        # Visual checkpoint #5. Check 'Afrikaans' page.
        eyes.check_window('Wysig jou profiel')

        # Click the 'Home' link.
        driver.find_element_by_css_selector('a.button:nth-child(4)').click()

        # Goto 'German' site:
        driver.find_element_by_css_selector('a.button:nth-child(4)').click()

        # Visual checkpoint #6. Check 'German' page.
        eyes.check_window('Bearbeite dein Profil')

        # End the test.
        eyes.close()

    finally:

        # Close the browser.
        driver.quit()

        # If the test was aborted before eyes.close was called, ends the test as aborted.
        eyes.abort_if_not_closed()
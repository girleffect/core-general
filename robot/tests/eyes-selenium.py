from selenium import webdriver
from selenium.webdriver.common import keys
from applitools.eyes import Eyes

class springster:

    eyes = Eyes()
    eyes.api_key = 'Nml08lERP106AWuL5kUAYeU4LyV5108l8IXQPozIPnnbzSU110'

    try:

        driver = webdriver.Chrome()

        eyes.open(driver=driver, app_name='Springster Demo', test_name='Springster UI test.',
        viewport_size={'width': 800, 'height': 600})
        
        driver.get('http://springster-example.qa-hub.ie.gehosting.org/')

        eyes.check_window('Springster Example - Sign in')

        driver.find_element_by_css_selector('a.button:nth-child(4)').click()

        eyes.check_window('Login')

        username = driver.find_element_by_css_selector('#id_auth-username');
        password = driver.find_element_by_css_selector('#id_auth-password');

        username.send_keys("klikl");
        password.send_keys("restore");

        driver.find_element_by_css_selector('#content > form > div.Form-buttons > input').click()

        eyes.check_window('Springster Example - Home page')

        driver.find_element_by_css_selector('#wagtail > div > div > div > div:nth-child(2) > a').click()

        eyes.check_window('Edit Your Profile')

        driver.execute_script("window.history.go(-1)")

        driver.find_element_by_css_selector('#wagtail > div > div > div > div:nth-child(5)').click()

        eyes.check_window('Wysig jou profiel')

        driver.execute_script("window.history.go(-1)")
        
        driver.find_element_by_css_selector('#wagtail > div > div > div > div:nth-child(6)').click()

        eyes.check_window('Bearbeite dein Profil')

        eyes.close()

    finally:

        # Close the browser.
        driver.quit()

        # If the test was aborted before eyes.close was called, ends the test as aborted.
        eyes.abort_if_not_closed()
*** Settings ***
Documentation     Automation test suite for Sauce Demo using Robot Framework.
Library           SeleniumLibrary

Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Go To Login Page

*** Variables ***
${URL}            https://saucedemo.com
${BROWSER}        chrome
${VALID_USER}     standard_user
${VALID_PASSWORD}    secret_sauce
${INVALID_USER}   locked_out_user

# Locators
${LOGIN_BUTTON}   id=login-button
${USERNAME_FIELD}    id=user-name
${PASSWORD_FIELD}    id=password
${ERROR_CONTAINER}    css=h3[data-test="error"]
${INVENTORY_CONTAINER}    css=.inventory_container
${ADD_TO_CART_BUTTON}    id=add-to-cart-sauce-labs-backpack
${CART_BADGE}     css=.shopping_cart_badge
${CART_LINK}      css=.shopping_cart_link
${CART_ITEM_NAME}    css=.inventory_item_name

*** Test Cases ***
Test Case 1: Login with valid credentials
    [Documentation]    Verify that the user lands on the products page after successful login.
    Login With Credentials    ${VALID_USER}    ${VALID_PASSWORD}
    Element Should Be Visible    ${INVENTORY_CONTAINER}
    Location Should Be    ${URL}inventory.html

Test Case 2: Attempt to login with invalid credentials
    [Documentation]    Verify that an appropriate error message is displayed on login failure.
    Login With Credentials    ${INVALID_USER}    ${VALID_PASSWORD}
    Element Should Be Visible    ${ERROR_CONTAINER}
    Element Text Should Mention Error

Test Case 3: Add a product to the cart and verify
    [Documentation]    Verify that a product can be added to the cart and appears correctly.
    Login With Credentials    ${VALID_USER}    ${VALID_PASSWORD}
    Click Button    ${ADD_TO_CART_BUTTON}
    Element Text Should Be    ${CART_BADGE}    1
    Click Link    ${CART_LINK}
    Element Should Be Visible    ${CART_ITEM_NAME}
    Element Text Should Be    ${CART_ITEM_NAME}    Sauce Labs Backpack

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0.5 seconds

Go To Login Page
    Go To    ${URL}

Login With Credentials
    [Arguments]    ${username}    ${password}
    Input Text     ${USERNAME_FIELD}    ${username}
    Input Text     ${PASSWORD_FIELD}    ${password}
    Click Button   ${LOGIN_BUTTON}

Element Text Should Mention Error
    ${error_text}=    Get Text    ${ERROR_CONTAINER}
    Should Contain    ${error_text}    Epic sadface

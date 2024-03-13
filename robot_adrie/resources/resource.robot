*** Settings ***
Documentation    Resource file for Automation Chalange @Author: Adrielson Pinheiro
Library           SeleniumLibrary
Library           Collections

*** Variables ***
${BROWSER}        Chrome
${BASE_URL}       http://automationexercise.com
${INITIAL_PAGE_LOCATOR}   //img[@src='/static/images/home/logo.png']
${PRODUCT_PAGE_LOCATOR}   //h2[@class='title text-center'][contains(.,'All Products')]
${SEARCH_BAR_LOCATOR}    //button[contains(@id,'submit_search')]
${SEARCH_FIELD_LOCATOR}  //input[contains(@id,'search_product')]
${SEARCH_RESULTS_LOCATOR}  //h2[@class='title text-center'][contains(.,'Searched Products')]
${ADDED_TO_CART_CONFIRMATION_LOCATOR}   //i[@class='material-icons'][contains(.,'')]
${GO_TO_CART_LOCATOR}   //*[@id="header"]//a[@href='/view_cart'][contains(.,'Cart')]
${CONTINUE_SHOPPING_LOCATOR}    //button[@class='btn btn-success close-modal btn-block'][contains(.,'Continue Shopping')]


*** Keywords ***
Open the Browser
    Open Browser  url=${BASE_URL}   browser=${BROWSER}
    maximize browser window
    wait until element is visible  locator=${INITIAL_PAGE_LOCATOR}

Close the Browser
    close browser

Navigate to Products Page
    Go To    url=${BASE_URL}/products
    wait until element is visible  locator=${PRODUCT_PAGE_LOCATOR}

Verify Search Bar is Visible
    Page Should Contain Element    locator=${SEARCH_BAR_LOCATOR}

Search for Product "${PRODUCT}"
    clear element text  ${SEARCH_FIELD_LOCATOR}
    Input Text    ${SEARCH_FIELD_LOCATOR}    ${PRODUCT}
    Click Element    ${SEARCH_BAR_LOCATOR}


Verify Product in Results "${PRODUCT}"
    wait until element is visible  locator=${SEARCH_RESULTS_LOCATOR}
    scroll element into view  locator=//a[contains(.,'View Product')]
#    page should contain element  locator=//img[contains(@alt,'ecommerce website products')]
    Page Should Contain  ${PRODUCT}

Add Product to Cart
     mouse over   locator=//img[contains(@alt,'ecommerce website products')]
     Click Element    locator=(//*[contains(text(),'Add to cart')])[2]
     wait until element is visible  locator=${ADDED_TO_CART_CONFIRMATION_LOCATOR}
     click element  locator=${CONTINUE_SHOPPING_LOCATOR}

Navigate to Cart
    Click Element    locator=${GO_TO_CART_LOCATOR}

Verify Products in Cart
    log to console  ${\n}
    [Arguments]    @{products}
    FOR    ${product}    IN    @{products}
           Page Should Contain    ${product}
    END

Verify Cart Total
    [Arguments]    @{products}
    ${price_first_product_with_currency}    Get Text    locator=//*[@id="product-2"]/td[5]
    log to console  ${price_first_product_with_currency}
    ${lowercase_price_1}=    Set Variable    ${price_first_product_with_currency.lower()}
    ${price_first_product}=    Evaluate    "${lowercase_price_1}".replace("rs. ", "")
    ${integer_value_1}=    Convert To Integer    ${price_first_product}
    log to console  Original Price: ${price_first_product_with_currency}
    log to console  Integer Value: ${price_first_product}

    ${price_second_product_with_currency}    Get Text    locator=//*[@id="product-7"]/td[5]
    log to console  ${price_second_product_with_currency}

    ${lowercase_price_2}=    Set Variable    ${price_second_product_with_currency.lower()}
    ${price_second_product}=    Evaluate    "${lowercase_price_2}".replace("rs. ", "")
    ${integer_value_2}=    Convert To Integer    ${price_second_product}
    log to console     Original Price: ${price_second_product_with_currency}
    log to console     Integer Value: ${price_second_product}

    ${SUM}  Evaluate    ${price_first_product} + ${price_second_product}
    log to console  What was the real amount is R$ ${SUM}


    ${total}=    Add Products    @{products}
    log to console  What the Function Calculates is R$ ${total}
    log to console  Sorry, I was not able to match what I got from page to a parameter... 

    ${expected_total}=    Add Products    @{products}
    Should Be Equal As Numbers    ${total}    ${expected_total}

Add Products
    [Arguments]    @{products}
    ${total}=    Set Variable    0
    FOR    ${product}    IN    @{products}
        ${price}=    Get Product Price    ${product}
        ${total}=    Evaluate    ${total} + ${price}
    END
    RETURN FROM KEYWORD  ${total}


Get Product Price
    [Arguments]    ${product}
    ${price}=    Run Keyword If    "${product} == 'Men Tshirt'"    Set Variable    400
    ...    ELSE IF    "${product} == 'Madame Top For Women'"    Set Variable    1000
    ...    ELSE    Log    Product not found: ${product}
    RETURN FROM KEYWORD    ${price}

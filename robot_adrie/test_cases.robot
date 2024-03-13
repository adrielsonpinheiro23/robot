*** Settings ***
Documentation    Test case for Automation Chalenge @Author: Adrielson Pinheiro
Resource         resource.robot
Test Setup  Open the Browser
Test Teardown  Close Browser

*** Variables ***
@{PRODUCTS}     Men Tshirt       Madame Top For Women

*** Test Cases ***
Test Case 1 - Adding products to cart and checking it
    Navigate to Products Page
    Verify Search Bar is Visible
    Search for Product "Men Tshirt"
    Verify Product in Results "Men Tshirt"
    Add Product to Cart
    Search for Product "Madame Top For Women"
    Verify Product in Results "Madame Top For Women"
    Add Product to Cart
    Navigate to Cart
    Verify Products in Cart     @{PRODUCTS}
    Verify Cart Total   @{PRODUCTS}

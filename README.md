# AppleQATest

A SwiftUI Apple Store–style demo application with a production-style XCTest UI automation framework.

This project demonstrates how to build a modern iOS application while implementing a scalable UI test architecture using XCTest, Page Object Model, and Xcode Test Plans with multi-environment and parallel execution support.

--------------------------------------------------

APPLICATION FEATURES

Product Catalog
- iPhone
- iPad
- MacBook
- Apple Pencil

Product Detail
- Variant selection (model)
- Color selection
- Storage selection
- Apple-style image gallery
- Multi-angle product images
- Add to cart

Cart
- Quantity update
- Subtotal calculation
- Cart summary

Checkout
- Promo code validation
- Shipping address validation
- Payment method validation
- Tax and total calculation
- Order placement

Profile
- First name
- Last name
- Phone number
- Email address
- Shipping address

Payment
- Cardholder name
- Card number
- Expiry validation
- CVV validation

--------------------------------------------------
## Demo

UI flow demonstration:

![App Demo](Screenshots/ui_tests.gif)
--------------------------------------------------

VALIDATION LAYER

Custom validators implemented for realistic data validation.

- CardValidator
- EmailValidator
- PhoneValidator
- AddressValidator
- LoginValidator

--------------------------------------------------

UI TEST AUTOMATION FRAMEWORK

The project includes a structured XCTest UI automation framework using the Page Object Model.

AppleQATestUITests

BaseUITestCase

Pages
- LoginPage
- ProductListPage
- ProductDetailPage
- CartPage
- CheckoutPage

Flows
- ProductDetailFlowTests
- CartQuantityTests
- CheckoutPromoTests
- OrderPlacementTests
- ProfileAddressPersistenceTests
- ProductConfigurationMatrixTests

--------------------------------------------------

TEST COVERAGE

Authentication
- User login validation

Product Flow
- Product selection
- Variant switching
- Storage selection
- Color selection
- Image gallery interaction

Cart
- Add to cart
- Quantity update
- Subtotal verification

Checkout
- Promo code validation
- Order placement
- Cart clearing after order

Profile
- Address persistence

Product Configuration Matrix Test

The ProductConfigurationMatrixTests verify:

Variant × Color × Storage combinations

ensuring every visible product configuration works correctly.

--------------------------------------------------

TEST PLANS

The project uses Xcode Test Plans to run the same test suite across multiple environments.

Supported Environments

DEV
QA
STAGING

Each configuration passes launch arguments:

-environment DEV
-environment QA
-environment STAGING

--------------------------------------------------

PARALLEL TEST EXECUTION

Tests support parallel execution across environments using:

- Xcode Test Plans
- Parallel simulator workers
- isolated app launch arguments

Example:

DEV      iPhone Simulator
QA       iPhone Simulator
STAGING  iPhone Simulator

Running simultaneously.

--------------------------------------------------

SCREENSHOT CAPTURE ON FAILURE

BaseUITestCase automatically captures screenshots when a test fails.

Example:

Failure - ProductConfigurationMatrixTests

This helps diagnose UI failures quickly.

--------------------------------------------------

TECHNOLOGIES USED

- SwiftUI
- XCTest
- Xcode Test Plans
- Page Object Model
- Accessibility-based UI testing
- Swift validation utilities

--------------------------------------------------

PROJECT STRUCTURE

AppleQATest

Models
- ProductCatalog
- ProductVariant
- ProductImageMapper

Managers
- CartManager
- UserProfileManager
- PaymentManager

Validators
- CardValidator
- EmailValidator
- PhoneValidator
- AddressValidator
- LoginValidator

Views
- LoginView
- ProductListView
- ProductDetailView
- CartView
- CheckoutView
- ProfileView
- PaymentView

AppleQATestUITests
- Pages
- Flows
- BaseUITestCase

--------------------------------------------------

RUNNING TESTS

Run in Xcode:

Command + U

Using Test Plans:

Run All Configurations

--------------------------------------------------

FUTURE IMPROVEMENTS

- API integration for product catalog
- UI snapshot testing
- GitHub Actions CI pipeline
- Device matrix testing
- Performance tests using XCTest



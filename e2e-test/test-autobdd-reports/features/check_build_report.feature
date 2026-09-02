@Report
Feature: test autobdd reports

  As a QA Engineer
  I want to inspect my automation build reports

  Scenario: check autorunner report
    When  :browser: I open the file "~/Projects/AutoBDD/test-projects/autobdd-test/test-results/e2e-test/autorunner-report/index.html"
    Then  :browser: I expect that the page title does equal the text "Multiple Cucumber HTML Reporter"
    And   :browser: I expect that the element "div.total" inside the 1st parent element "table.chart" does contain the text "5"
    And   :browser: I expect that the 1st element "table.tile_info" does match the regex "Passed[\s]+100.00 %[\s]+Failed[\s]+0.00 %"
    And   :browser: I expect that the element "div.total" inside the 2nd parent element "table.chart" does contain the text "14"
    And   :browser: I expect that the 2nd element "table.tile_info" does match the regex "Passed[\s]+100.00 %[\s]+Failed[\s]+0.00 %"

  Scenario: check prunner report
    When  :browser: I open the file "~/Projects/AutoBDD/test-projects/autobdd-test/test-results/e2e-test/prunner-report/index.html"
    Then  :browser: I expect that the page title does equal the text "Multiple Cucumber HTML Reporter"
    And   :browser: I expect that the element "div.total" inside the 1st parent element "table.chart" does contain the text "5"
    And   :browser: I expect that the 1st element "table.tile_info" does match the regex "Passed[\s]+100.00 %[\s]+Failed[\s]+0.00 %"
    And   :browser: I expect that the element "div.total" inside the 2nd parent element "table.chart" does contain the text "14"
    And   :browser: I expect that the 2nd element "table.tile_info" does match the regex "Passed[\s]+100.00 %[\s]+Failed[\s]+0.00 %"

  Scenario: check arunner report
    When  :browser: I open the file "~/Projects/AutoBDD/test-projects/autobdd-test/test-results/e2e-test/arunner-report/index.html"
    Then  :browser: I expect that the page title does equal the text "Multiple Cucumber HTML Reporter"
    And   :browser: I expect that the element "div.total" inside the 1st parent element "table.chart" does contain the text "1"
    And   :browser: I expect that the 1st element "table.tile_info" does match the regex "Passed[\s]+100.00 %[\s]+Failed[\s]+0.00 %"
    And   :browser: I expect that the element "div.total" inside the 2nd parent element "table.chart" does contain the text "1"
    And   :browser: I expect that the 2nd element "table.tile_info" does match the regex "Passed[\s]+100.00 %[\s]+Failed[\s]+0.00 %"

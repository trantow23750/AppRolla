Feature: Write Text

  Scenario: Write Text
    When I write the text "this is some text"
    Then I see "this is some text"
    When I clear the text
    Then I do not see "this is some text"

  Scenario: Clickety Click
    Then I see one button
    And it has the text "clicky click"

  Scenario: Click text
    When I click the text "click this text"
    And I click the text "WELL DONE"
    Then I see "WELL DONE"

  Scenario: Content
    Then I see the content "click this text"

  Scenario: Views
    Then I see all views

  Scenario: List Text Views
    Then I see text views

  Scenario: All Content
    Then I see all content

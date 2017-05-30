package com.acouchi;

import com.jayway.android.robotium.solo.Solo;

import java.util.ArrayList;
import android.util.Log;

import com.google.gson.Gson;

import com.acouchi.JsonResult;
import com.acouchi.JsonView;
import com.acouchi.JsonButton;
import com.acouchi.JsonTextView;

import android.view.View;
import android.widget.TextView;
import android.widget.Button;

public class MethodExecutor
{
  private Solo solo;
  private String methodName;
  private String[] parameters;

  public MethodExecutor(Solo solo, String methodName, String[] parameters)
  {
    this.solo = solo;
    this.methodName = methodName;
    this.parameters = parameters;
  }

  public String Execute()
  {
    Object result = null;

    if (methodName.equals("getCurrentContent"))
      result = getCurrentContent();

    if (methodName.equals("enterText"))
      solo.enterText(Integer.parseInt(parameters[0]), parameters[1]);

    if (methodName.equals("clickOnText"))
      solo.clickOnText(parameters[0], Integer.parseInt(parameters[1]), Boolean.parseBoolean(parameters[2]));

    if (methodName.equals("scrollUpList"))
      result = solo.scrollUpList(Integer.parseInt(parameters[0]));

    if (methodName.equals("scrollDownList"))
      result = solo.scrollDownList(Integer.parseInt(parameters[0]));

    if (methodName.equals("sendKey"))
      solo.sendKey(Integer.parseInt(parameters[0]));

    if (methodName.equals("clearEditText"))
      solo.clearEditText(Integer.parseInt(parameters[0]));

    if (methodName.equals("searchText"))
      result = solo.searchText(parameters[0], Integer.parseInt(parameters[1]), Boolean.parseBoolean(parameters[2]), Boolean.parseBoolean(parameters[3]));

    if (methodName.equals("getCurrentButtons"))
      result = getCurrentButtons();

    if (methodName.equals("getCurrentContent"))
      result = getCurrentContent();

    if (methodName.equals("getViews"))
      result = getCurrentViews();

    if (methodName.equals("getTextViews"))
      result = getCurrentTextViews();

    if (methodName.equals("clickOnViewById"))
      clickOnViewById(Integer.parseInt(parameters[0]));

    if (methodName.equals("clickOnImage"))
      solo.clickOnImage(Integer.parseInt(parameters[0]));

    if (methodName.equals("clickOnMenuItem"))
      solo.clickOnMenuItem(parameters[0], Boolean.parseBoolean(parameters[1]));

    if (methodName.equals("scrollUp"))
      result = solo.scrollUp();

    if (methodName.equals("scrollDown"))
      result = solo.scrollDown();

    if (methodName.equals("scrollToSide"))
      solo.scrollToSide(Integer.parseInt(parameters[0]));

    if (methodName.equals("goBack"))
      solo.goBack();

    if (methodName.equals("waitForText"))
      result = solo.waitForText(parameters[0], Integer.parseInt(parameters[1]), Long.parseLong(parameters[2]), Boolean.parseBoolean(parameters[3]), Boolean.parseBoolean(parameters[4]));

    return methodResultAsJson(result);
  }

  public void clickOnViewById(int id)
  {
    solo.clickOnView(solo.getView(id));
  }

  private ArrayList<JsonButton> getCurrentButtons()
  {
    ArrayList<JsonButton> jsonButtons = new ArrayList<JsonButton>();
    for(Button button: solo.getCurrentButtons())
      jsonButtons.add(new JsonButton(button));
    return jsonButtons;
  }

  private String methodResultAsJson(Object result)
  {
    JsonResult jsonResult = new JsonResult(result);
    return new Gson().toJson(jsonResult);
  }

  private ArrayList<String> getCurrentContent()
  {
    ArrayList<TextView> currentTextViews = solo.getCurrentTextViews(null);
    ArrayList<String> content = new ArrayList<String>();
    for (TextView textView: currentTextViews)
      content.add(textView.getText().toString());
    return content;
  }

  private ArrayList<JsonView> getCurrentViews()
  {
    ArrayList<JsonView> jsonViews = new ArrayList<JsonView>();
    for (View view: solo.getViews())
      jsonViews.add(new JsonView(view));
    return jsonViews;
  }

  private ArrayList<JsonTextView> getCurrentTextViews()
  {
    ArrayList<JsonTextView> jsonTextViews = new ArrayList<JsonTextView>();
    for (TextView textView: solo.getCurrentTextViews(null))
      jsonTextViews.add(new JsonTextView(textView));
    return jsonTextViews;
  }
}

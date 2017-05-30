package com.acouchi;

import android.widget.Button;

public class JsonButton
{
  private String text;

  public JsonButton(Button button)
  {
    text = button.getText().toString();
  }
}

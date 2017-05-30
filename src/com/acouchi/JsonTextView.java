package com.acouchi;

import android.view.View;
import android.widget.TextView;

public class JsonTextView extends JsonView
{
  private String text;

  public JsonTextView(TextView textView)
  {
    super(textView);
    text = textView.getText().toString();
  }
}

package com.acouchi;

import android.view.View;

public class JsonView
{
  private int id;
  private String className;
  private Boolean shown;

  public JsonView(View view)
  {
    id = view.getId();
    className = view.getClass().toString();
    shown = view.isShown();
  }
}

package com.acouchi;

import com.jayway.android.robotium.solo.Solo;

import java.util.Properties;
import java.io.File;
import java.io.IOException;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import android.util.Log;
import com.google.gson.Gson;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.Writer;

public class Acouchi extends NanoHTTPD
{
  private Solo solo;
  private boolean serverRunning = true;
  private Lock lock = new ReentrantLock();
  private Condition endedCondition = lock.newCondition();

  public Acouchi(Solo solo) throws IOException
  {
    super(7103, new File("."));
    this.solo = solo;
  }

  public void WaitUntilServerKilled() throws InterruptedException
  {
    lock.lock();
    try {
      while(serverRunning)
      {
        endedCondition.await();
      }
    }
    finally {
      lock.unlock();
    }
  }

  public Response serve(String uri, String method, Properties header, Properties params, Properties files )
  {
    if (uri.endsWith("/finish"))
    {
      try {
        serverRunning = false;
        stop();
        endedCondition.signal();
      }
      finally {
        lock.unlock();
      }
      return new NanoHTTPD.Response(HTTP_OK, MIME_HTML, "");
    }
    else if (uri.startsWith("/execute_method"))
    {
      try {
        String methodName = uri.replace("/execute_method/", "");
        String[] parameters = new Gson().fromJson(params.getProperty("parameters"), String[].class);
        String jsonResult = new MethodExecutor(solo, methodName, parameters).Execute();

        return new NanoHTTPD.Response(HTTP_OK, MIME_HTML, jsonResult);
      } catch (Throwable throwable) {
        return showException(throwable);
      }
    }
    return new NanoHTTPD.Response(HTTP_OK, MIME_HTML, "Acouchi");
  }

  private NanoHTTPD.Response showException(Throwable throwable)
  {
    final Writer result = new StringWriter();
    final PrintWriter printWriter = new PrintWriter(result);
    throwable.printStackTrace(printWriter);
    return new NanoHTTPD.Response(HTTP_OK, MIME_HTML, "error: " + throwable.getMessage() + "\n" + result.toString());
  }
}

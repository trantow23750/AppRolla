package com.acouchi.sample;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;
import android.view.View.OnClickListener;
import android.view.View;
import android.widget.ImageView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import java.util.Arrays;
import java.util.ArrayList;

public class StartupActivity extends Activity
{
  private ListView listView;
  private ArrayAdapter<String> listAdapter;

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        TextView clickThis = (TextView)findViewById(R.id.clickThisText);
        clickThis.setOnClickListener(new OnClickListener(){
          public void onClick(View v) {
              TextView clickThis = (TextView)findViewById(R.id.clickThisText);
              clickThis.setText("WELL DONE");
          }
        });

        ImageView imageView = (ImageView)findViewById(R.id.clickThisImageView);
        imageView.setOnClickListener(new OnClickListener(){
          public void onClick(View v) {
            TextView clickThis = (TextView)findViewById(R.id.clickThisText);
            clickThis.setText("You click an ImageView");
          }
        });

        listView = (ListView) findViewById( R.id.listView );
        String[] planets = new String[] {
                                          "1", "2", "3", "4", "5", "6", "7", "8",
                                          "9", "10", "11", "12", "13", "14", "15",
                                          "16", "17", "18", "19", "20", "21", "22"
                                        };
        ArrayList<String> planetList = new ArrayList<String>();
        planetList.addAll(Arrays.asList(planets));
        listAdapter = new ArrayAdapter<String>(this, R.layout.listviewrow, planetList);
        listView.setAdapter(listAdapter);
    }
}

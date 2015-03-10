package com.example.matt.sparkworkout;

import android.app.ProgressDialog;
import android.support.v7.app.ActionBarActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;
import org.apache.http.Header;
import org.json.JSONException;
import org.json.JSONObject;
import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.JsonHttpResponseHandler;
import com.loopj.android.http.RequestParams;
public class MainActivity extends ActionBarActivity {
    // Progress Dialog Object
    ProgressDialog progressDialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        progressDialog = new ProgressDialog(this);
        // Set Progress Dialog Text
        progressDialog.setMessage("Please wait...");
        progressDialog.setCancelable(false);
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();
        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }
        return super.onOptionsItemSelected(item);
    }
    /** Called when the user touches the Save Workout button */
    public void saveWorkout(View view) {
        // Gather up the text input
        String type = ((EditText) findViewById(R.id.type)).getText().toString();
        String name = ((EditText) findViewById(R.id.name)).getText().toString();
        String number_of_reps = ((EditText) findViewById(R.id.number_of_reps)).getText().toString();
        String weight = ((EditText) findViewById(R.id.weight)).getText().toString();
        String comment = ((EditText) findViewById(R.id.comment)).getText().toString();
        // Instantiate Http Request Param Object
        RequestParams params = new RequestParams();
        // Make sure that a type and name were entered
        if (type != null &&
                !"".equals(type) &&
                name != null &&
                !"".equals(name)) {
            // Store the parameters
            params.put("type", type);
            params.put("name", name);
            params.put("number_of_reps", number_of_reps);
            params.put("weight", weight);
            params.put("comment", comment);
            // Call the web service
            callSaveWorkoutWebService(params);
        } else {
            Toast.makeText(getApplicationContext(),
                    "Please fill in the Type and Name.",
                    Toast.LENGTH_LONG).show();
        }
    }
    /**
     * Method that performs RESTful webservice invocations
     *
     * @param params the JSON parameters that will be sent
     */
    public void callSaveWorkoutWebService(RequestParams params){
        // Show Progress Dialog
        progressDialog.show();
        // Make RESTful webservice call using AsyncHttpClient object
        AsyncHttpClient client = new AsyncHttpClient();
        client.post("http://localhost:port/saveWorkout",
                params,
                new JsonHttpResponseHandler() {
                    // When the response returned by REST has Http response code '200'
                    @Override
                    public void onSuccess(int statusCode,
                                          Header[] headers,
                                          JSONObject response) {
                        // Hide Progress Dialog
                        progressDialog.hide();
                        try {
                            // When the JSON response has status boolean value assigned with true
                            if (response.getBoolean("status")) {
                                Toast.makeText(getApplicationContext(),
                                        "Workout successfully saved.",
                                        Toast.LENGTH_LONG).show();
                            }
                            // Else display error message
                            else {
                                Toast.makeText(getApplicationContext(),
                                        response.getString("error_msg"),
                                        Toast.LENGTH_LONG).show();
                            }
                        } catch (JSONException e) {
                            Toast.makeText(getApplicationContext(),
                                    "Error Occurred",
                                    Toast.LENGTH_LONG).show();
                            e.printStackTrace();
                        }
                    }
                    // When the response returned by REST has Http response code other than '200'
                    @Override
                    public void onFailure(int statusCode,
                                          Header[] headers,
                                          Throwable e,
                                          JSONObject errorResponse) {
                        // Hide Progress Dialog
                        progressDialog.hide();
                        // When Http response code is '404'
                        if (statusCode == 404) {
                            Toast.makeText(getApplicationContext(),
                                    "Requested resource not found",
                                    Toast.LENGTH_LONG).show();
                        }
                        // When Http response code is '500'
                        else if (statusCode == 500) {
                            Toast.makeText(getApplicationContext(),
                                    "Something went wrong at server end",
                                    Toast.LENGTH_LONG).show();
                        }
                        // When Http response code other than 404, 500
                        else {
                            Toast.makeText(getApplicationContext(),
                                    "Unexpected Error occurred",
                                    Toast.LENGTH_LONG).show();
                        }
                    }
                });
    }
}
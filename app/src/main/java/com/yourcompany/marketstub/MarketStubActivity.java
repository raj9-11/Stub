package com.yourcompany.marketstub;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

public class MarketStubActivity extends Activity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Uri uri = getIntent().getData();
    if (uri != null) {
      Intent i = new Intent(Intent.ACTION_VIEW, uri);
      i.setPackage("com.android.vending");
      i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      startActivity(i);
    }
    finish();
  }
}

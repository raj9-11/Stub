#!/usr/bin/env bash
set -e

# 1) Clean any prior output
rm -rf MarketStub MarketStub.zip

# 2) Create directory structure
mkdir -p MarketStub/app/src/main/java/com/yourcompany/marketstub
mkdir -p MarketStub/gradle/wrapper

# 3) Generate root settings.gradle
cat > MarketStub/settings.gradle << 'EOF'
rootProject.name = "MarketStub"
include ":app"
EOF

# 4) Generate root build.gradle
cat > MarketStub/build.gradle << 'EOF'
plugins {
  id 'com.android.application' version '8.1.0' apply false
}
task wrapper(type: Wrapper) {
  gradleVersion = '8.2'
}
EOF

# 5) Gradle wrapper properties
cat > MarketStub/gradle/wrapper/gradle-wrapper.properties << 'EOF'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.2-bin.zip
EOF

# 6) App module build.gradle
cat > MarketStub/app/build.gradle << 'EOF'
apply plugin: 'com.android.application'

android {
  compileSdk = 34
  defaultConfig {
    applicationId = "com.yourcompany.marketstub"
    minSdk = 21
    targetSdk = 34
    versionCode = 1
    versionName = "1.0"
  }
  buildTypes {
    release {
      minifyEnabled false
    }
  }
}

dependencies {
  // no external deps
}
EOF

# 7) AndroidManifest.xml
cat > MarketStub/app/src/main/AndroidManifest.xml << 'EOF'
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.yourcompany.marketstub">

  <application android:label="Market Stub">
    <activity android:name=".MarketStubActivity"
              android:exported="true">
      <intent-filter>
        <action android:name="android.intent.action.VIEW"/>
        <category android:name="android.intent.category.DEFAULT"/>
        <category android:name="android.intent.category.BROWSABLE"/>
        <data android:scheme="market"/>
      </intent-filter>
    </activity>
  </application>
</manifest>
EOF

# 8) MarketStubActivity.java
cat > MarketStub/app/src/main/java/com/yourcompany/marketstub/MarketStubActivity.java << 'EOF'
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
EOF

# 9) Zip it all up
(cd MarketStub && zip -r ../MarketStub.zip .)

echo "✅ MarketStub.zip created successfully in $(pwd)"
echo "Contents:"
unzip -l MarketStub.zip | sed 's/^/  /'

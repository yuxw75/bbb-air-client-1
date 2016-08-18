
Add extra arguments to Flex Compiler:

* right-click on bbb-air-client project
* Properties-Flex Compiler
* add the following as Additional compiler arguments:

```
-locale=en_US,pt_BR -source-path=./locale/{locale} -resource-bundle-list=used-resource-bundles.txt -allow-source-path-overlap=true
```

Include the Air Native Extensions (ANE) in the project:

* Project -> Properties -> Flex Build Path -> Native Extensions -> Add ANE...
* Select the *.ane files in the bbb-air-client\libs folder
* still on project properties, go to Flex Build Packaging -> Apple iOS -> Native Extensions
* check the Package checkbox for the ane files, do the same for android on Flex Build Packaging -> Google Android
* on Flex Build Packaging -> BlackBerry Tablet OS, uncheck "enable this target platform" 

Everytime you change the localization files (and when you first compile the client), run *build-locale.bat* to compile the localization resources.

By default, when you run the app in debug mode, you will join the *Demo Meeting* on http://test-install.blindsidenetworks.com/, but only if you open the session first in your browser. The app will never call *create*, it only knows how to handle *join*.

In order to package the app for iOS, you will need a more recent version of Air SDK (Adobe Flash Builder 4.6 comes with Air SDK 3.1).
To install the most recent Air SDK on Mac OS, you can follow this tutorial: http://jeffwinder.blogspot.com.br/2011/09/installing-adobe-air-3-sdk-in-flash.html (on Windows should be something similar).

On windows you can follow this tutorial: 
http://www.andygup.net/how-to-upgrade-your-air-sdk-in-flashbuilder-4-6/

**Important: you should download the original AIR SDK without the new compiler, or you will face a bunch of weird messages during project compilation.
You can find it here: http://airdownload.adobe.com/air/win/download/latest/AdobeAIRSDK.zip



-locale zh_CN -locale en_US  -source-path=./locale/{locale} -resource-bundle-list=used-resource-bundles.txt -allow-source-path-overlap=true

url = "http://112.74.96.171/bigbluebutton/api/join?meetingID=1361469443566213&password=md&fullName=%E4%BD%99%E6%99%93%E6%96%87&logoutURL=http://lwork.hk&checksum=0753029db8c2fc6ed0ff34a9a01565295327a812";
//url = "https://demo.bigbluebutton.org/bigbluebutton/api/join?meetingID=Demo+Meeting&fullName=ssss&password=mp&checksum=54c5a668bc8002c7efc439f15954a7b7bb6b4a6c";


com.livecom.lworkvideo
livecom2015
https://www.pgyer.com/C6gO



"bigbluebutton://112.74.96.171/bigbluebutton/api/join?meetingID=1361469443566213&password=md&fullName=%E4%BD%99%E6%99%93%E6%96%87&logoutURL=http://lwork.hk&checksum=0753029db8c2fc6ed0ff34a9a01565295327a812";
		


MenuButtonsViewMediator.as  app传值
LoginPageViewMediator.as    app传值
		  
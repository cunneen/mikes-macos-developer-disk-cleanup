# Awk file to parse android sdkmanager output. Used by the android-sdk.sh function, but could potentially be used as below.
# 
# USAGE:
#   sdkmanager --list_installed --include_obsolete | awk -f "android-sdk.awk" -v outputFile="android-sdk-packages-to-remove.txt"
#
# This will return with an exit status of 0 if there *are* packages to remove. In which case, they can be removed via sdkmanager as follows:
# 
#   sdkmanager --uninstall --package_file=android-sdk-packages-to-remove.txt
#
# Output will be a list of packages to remove. Only the most recent version of each package category will be retained.
# 
# sdkmanager output format is like this:
#
# Installed packages:
#   Path                                                     | Version       | Description                                     | Location                                                
#   -------                                                  | -------       | -------                                         | -------                                                 
#   build-tools;30.0.3                                       | 30.0.3        | Android SDK Build-Tools 30.0.3                  | build-tools/30.0.3                                      
#   build-tools;33.0.2                                       | 33.0.2        | Android SDK Build-Tools 33.0.2                  | build-tools/33.0.2                                      
#   build-tools;34.0.0                                       | 34.0.0        | Android SDK Build-Tools 34                      | build-tools/34.0.0                                      
#   build-tools;35.0.0                                       | 35.0.0        | Android SDK Build-Tools 35                      | build-tools/35.0.0                                      
#   cmake;3.18.1                                             | 3.18.1        | CMake 3.18.1                                    | cmake/3.18.1                                            
#   cmake;3.22.1                                             | 3.22.1        | CMake 3.22.1                                    | cmake/3.22.1                                            
#   cmdline-tools;latest                                     | 9.0           | Android SDK Command-line Tools (latest)         | cmdline-tools/latest                                    
#   emulator                                                 | 35.1.20       | Android Emulator                                | emulator                                                
#   extras;intel;Hardware_Accelerated_Execution_Manager      | 7.6.5         | Intel x86 Emulator Accelerator (HAXM installer) | extras/intel/Hardware_Accelerated_Execution_Manager     
#   ndk;23.1.7779620                                         | 23.1.7779620  | NDK (Side by side) 23.1.7779620                 | ndk/23.1.7779620                                        
#   ndk;25.1.8937393                                         | 25.1.8937393  | NDK (Side by side) 25.1.8937393                 | ndk/25.1.8937393                                        
#   ndk;26.1.10909125                                        | 26.1.10909125 | NDK (Side by side) 26.1.10909125                | ndk/26.1.10909125                                       
#   patcher;v4                                               | 1             | SDK Patch Applier v4                            | patcher/v4                                              
#   platform-tools                                           | 35.0.2        | Android SDK Platform-Tools                      | platform-tools                                          
#   platforms;android-26                                     | 2             | Android SDK Platform 26                         | platforms/android-26                                    
#   platforms;android-27                                     | 3             | Android SDK Platform 27                         | platforms/android-27                                    
#   platforms;android-28                                     | 6             | Android SDK Platform 28                         | platforms/android-28                                    
#   platforms;android-30                                     | 3             | Android SDK Platform 30                         | platforms/android-30                                    
#   platforms;android-31                                     | 1             | Android SDK Platform 31                         | platforms/android-31                                    
#   platforms;android-33                                     | 3             | Android SDK Platform 33                         | platforms/android-33                                    
#   platforms;android-34                                     | 3             | Android SDK Platform 34                         | platforms/android-34                                    
#   platforms;android-35                                     | 1             | Android SDK Platform 35                         | platforms/android-35                                    
#   sources;android-30                                       | 1             | Sources for Android 30                          | sources/android-30                                      
#   sources;android-33                                       | 1             | Sources for Android 33                          | sources/android-33                                      
#   sources;android-35                                       | 1             | Sources for Android 35                          | sources/android-35                                      
#   system-images;android-30;google_apis;x86                 | 9             | Google APIs Intel x86 Atom System Image         | system-images/android-30/google_apis/x86                
#   system-images;android-30;google_apis_playstore;arm64-v8a | 9             | Google Play ARM 64 v8a System Image             | system-images/android-30/google_apis_playstore/arm64-v8a
#   system-images;android-31;google_apis;arm64-v8a           | 10            | Google APIs ARM 64 v8a System Image             | system-images/android-31/google_apis/arm64-v8a          
#   system-images;android-31;google_apis_playstore;arm64-v8a | 9             | Google Play ARM 64 v8a System Image             | system-images/android-31/google_apis_playstore/arm64-v8a
#   system-images;android-32;google_apis_playstore;arm64-v8a | 3             | Google Play ARM 64 v8a System Image             | system-images/android-32/google_apis_playstore/arm64-v8a
#   system-images;android-33;google_apis_playstore;arm64-v8a | 7             | Google Play ARM 64 v8a System Image             | system-images/android-33/google_apis_playstore/arm64-v8a
#   system-images;android-34;google_apis_playstore;arm64-v8a | 8             | Google Play ARM 64 v8a System Image             | system-images/android-34/google_apis_playstore/arm64-v8a
#   system-images;android-34;google_atd;arm64-v8a            | 1             | Google APIs ATD ARM 64 System Image             | system-images/android-34/google_atd/arm64-v8a           
# 
# Installed Obsolete Packages:
#   Path                | Version | Description            | Location           
#   -------             | ------- | -------                | -------            
#   platforms;android-2 | 1       | Android SDK Platform 2 | platforms/android-2
#   tools               | 26.1.1  | Android SDK Tools      | tools              
# 

BEGIN{
    if (outputFile == "") {
        outputFile="android-sdk-packages-to-remove.txt";
    } 
    lastPath="";
    lastCat="";
    delete itemsToRemove[0]; # initializes a new array
    itemsToRemoveLength=0; # length of array
}
/Installed packages:/{
    inInstalled=1;
    inObsolete=0;
}
/Installed Obsolete Packages:/{
    inInstalled=0;
    inObsolete=1;
}
/\;/{
    path=$1; 
    version=$3;
    loc=$NF; # last field is location; description has spaces to hard to grab
    cat=path; 
    gsub(/;.+$/,"",cat); # the category is just the first portion of the path before the semicolon e.g. "platforms"
    if (inInstalled) {
        # If this category is the same as the last one, add the 
        #  previous record to our list of ones to remove (and keep only the most recent).
        if (cat == lastCat) {
            # add the last category as a new item on the end of our array
            itemsToRemoveLength++;
            itemsToRemove[itemsToRemoveLength] = lastPath;
        } else {
            # we're in a new category
        }
        lastCat = cat;
        lastPath = path;
    } else if (inObsolete) {
        # we'll just add all obsolete packages to the list of items to remove
        itemsToRemoveLength++;
        itemsToRemove[itemsToRemoveLength] = path;
    }
}
END{
    if (itemsToRemoveLength == 0) {
        # nothing to remove; exit with an error state of 1
        exit 1;
    }
    # truncate the outputFile
    printf("") > outputFile;
    # print out the items to remove
    for(i=1; i<=itemsToRemoveLength; i++) {
        printf("%s\n", itemsToRemove[i]) >> outputFile;
    }
}
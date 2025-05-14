# Usage:
#   export CACHEPATH=$(realpath $HOME/Library/Caches );
#   lsof -w -b +c 32 -n | awk -v CACHEPATH=$CACHEPATH -f library-caches-lsof-output.awk

function getProcessNames(retString) {
  for(proc in processes) {
    if (proc != ""){
      retString=retString""sprintf("%s:", proc);
      # retString=retString""processes[proc];
      split(processes[proc], theseFolders, ";");
      for(folder in theseFolders) {
        if (theseFolders[folder] != "" && (theseFolders[folder] in folderSizes)) {
          retString=retString""sprintf("%s (%'dKB),", theseFolders[folder], folderSizes[theseFolders[folder]]);
        }
      }
      retString=retString"\n";
    }
  }
  return retString;
}

function getCacheFoldersByName(retString) {
  for(cacheFolder in folders) {
    if (cacheFolder != "" && (cacheFolder in folderSizes)) {
      retString=retString""sprintf("%s (%'dKB):", cacheFolder, folderSizes[cacheFolder]);
      retString=retString""folders[cacheFolder];
      # split(folders[cacheFolder], theseProcesses, ";");
      # for(proc in theseProcesses) {
      #   if (theseProcesses[proc] != "") {
      #     retString=retString""sprintf("%s,", theseProcesses[proc]);
      #   }
      # }
      retString=retString"\n";
    } 
  }
  return retString;
}

function getCacheFoldersBySize(retString) {
  for(cacheFolder in folders) {
    if (cacheFolder != "" && (cacheFolder in folderSizes)) {
      retString=retString""sprintf("%s (%'dKB)%s:", folderSizes[cacheFolder], folderSizes[cacheFolder], cacheFolder);
      retString=retString""folders[cacheFolder];
      # split(folders[cacheFolder], theseProcesses, ";");
      # for(proc in theseProcesses) {
      #   if (theseProcesses[proc] != "") {
      #     retString=retString""sprintf("%s,", theseProcesses[proc]);
      #   }
      # }
      retString=retString"\n";
    } 
  }
  return retString;
}


BEGIN {
    if (CACHEPATH == "") {
        CACHEPATH=$HOME"/Library/Caches";
    } 
    delete processes[0]; # initializes a new array
    delete folders[0]; # initializes a new array
    delete folderSizes[0]; # initializes a new array
    totalSizesOfFoldersInUse = 0;
}

($9 ~ CACHEPATH) && 
!($9 ~ "com.apple.") &&
!($9 ~ "CloudKit") && 
!($9 ~ "familycircled") && 
!($9 ~ "GeoServices") {
  pathcopy = $9; 
  gsub(CACHEPATH"/", "", pathcopy); 
  gsub(/\/.*$/, "", pathcopy);
  processName = $1;
  libraryCacheFolder = pathcopy; 
  # printf("%s\t%s\n", processName, libraryCacheFolder);
  if (processName in processes) {
    existingFolderValsString = processes[processName];
    split(existingFolderValsString, existingFolderValsArray, ";");
    recorded = 0;
    for(thisFolderIdx in existingFolderValsArray) {
      if (existingFolderValsArray[thisFolderIdx] == libraryCacheFolder) {
        recorded = 1;
        break;
      }
    }
    if (recorded == 0) {
      processes[processName] = processes[processName]";"libraryCacheFolder;
    }
  } else {
    if (processName != "" && libraryCacheFolder != "") {
      processes[processName]=libraryCacheFolder;
    }
  }
  if (libraryCacheFolder in folders) {
    existingProcessValsString = folders[libraryCacheFolder];
    split(existingProcessValsString, existingProcessValsArray, ";");
    recorded = 0;
    for(thisProcIdx in existingProcessValsArray) {
      if (existingProcessValsArray[thisProcIdx] == processName) {
        recorded = 1;
        break;
      }
    }
    if (recorded == 0) {
      folders[libraryCacheFolder] = folders[libraryCacheFolder]";"processName
    }
  } else {
    if (processName != "" && libraryCacheFolder != "") {
      folders[libraryCacheFolder]=processName;
      # get disk size
      # -ks : summary in kilobytes; -t 5M : threshold of 5MB
      # duCmd = "du -n -x -ks -t 5M "CACHEPATH"/"libraryCacheFolder" 2>/dev/null | cut -f1" ;
      duCmd = "du -n -x -ks "CACHEPATH"/"libraryCacheFolder" 2>/dev/null | cut -f1" ;
      duCmd | getline duOutput;
      close(duCmd);
      folderSizes[libraryCacheFolder] = duOutput;
      totalSizesOfFoldersInUse += duOutput;
      # printf("DUCMD: %s\n", duCmd)
    }
  }
}
END {
  printf("  --- PROCESSES USING CACHE FILES: ---\n");
  # printf(getProcessNames()) | "sort";
  # fflush();
  # printf("\n");
  # printf("  --- CACHE FOLDERS IN USE (By NAME): ---\n");
  # printf(getCacheFoldersByName()) | "sort";
  # fflush();
  # printf("\n");
  printf("  --- CACHE FOLDERS IN USE (By SIZE): ---\n");
  printf(getCacheFoldersBySize()) | "sort -rn";
  fflush();
  printf("\n");
  printf ("  --- TOTAL SIZE OF FOLDERS IN USE: %s KB\n", totalSizesOfFoldersInUse);
}
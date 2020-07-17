function prompt { 
    $host.ui.rawui.WindowTitle = $(get-location)      
    $prompt_string = ""
    
    if(Test-Path .git) {
    
        $prompt_string = "GIT "
        git branch | foreach {
            if ($_ -match "^\*(.*)"){
            $prompt_string += "[" + $matches[1] + "] "
            }
        }
        
        $differences = (git diff-index --name-status HEAD)
        if($differences -ne $NULL){
           $git_update_count = [regex]::matches($differences, "M`t").count
           $git_create_count = [regex]::matches($differences, "A`t").count
           $git_delete_count = [regex]::matches($differences, "D`t").count
           $prompt_string += "c:" + $git_create_count + " u:" + $git_update_count + " d:" + $git_delete_count + " | > "
           Write-Host ($prompt_string) -nonewline -foregroundcolor yellow
        }
        else{
           $prompt_string += "> " 
           if((git log origin/master..HEAD) -ne $NULL){
              Write-Host ($prompt_string) -nonewline -backgroundcolor red -foregroundcolor white
           }else{
              Write-Host ($prompt_string) -nonewline -foregroundcolor green} 
        }
    
    }
    else{
        $prompt_string = "PS " + $host.ui.rawui.WindowTitle + ">"
        Write-Host ($prompt_string) -nonewline -foregroundcolor green
    }
    
    
    return " "
}
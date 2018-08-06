# Contribution guidance

Try to use best practices, most of our code is PowerShell, at least to start with, so do things "The PowerShell Way". If you dont know what this means then you need to re-read Don Jones' books!

This is early days so code that is rough around the edges and not fully formed are expected to begin with. However, there are a few basics best practices we can all get into the habit of.

So, a few notes:

### Every new cmdlet should provide help and examples
Ensure that you include comment-based help in all new cmdlets. Help should include a completed Synopsis, and placeholders for Description, Parameters and Examples as a minimum. 

Use the Description to give a fuller explanation and this can be used to detail capabilities and limitations, as well as notes for extra work that might be needed.

### Cmdlets will have to use common verbs
 
The verb of a cmdlet (get-, add-, etc.) should follow acceptable cmdlet standards. Read this article and try to apply the same principles: https://docs.microsoft.com/en-us/powershell/developer/cmdlet/approved-verbs-for-windows-powershell-commands

### Cmdlet nouns will have to be pre-fixed
The noun of a cmdlet should be pre-fixed with 'fa' e.g. Get-faClient. This is important to help avoid potential naming conflicts and help to clearly distinguish what code is ours.

### Parameter splatting
Don't use backtick characters: ` for line-breaks. Use parameter splatting to help with readability of code. 

You dont need to do this for every command, but where your declaring several properties and line-wrapping in the IDE becomes and issue, use this technique.
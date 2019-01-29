
#### FIELD/COLUMN TYPES ####
#Single Line of Text    = Text
#Multiple Lines of Text = Note
#Number                 = Number
#Yes/No                 = Boolean
#Person                 = User
#Date                   = DateTime
#Choice                 = Choice
#Hyperlink              = Url
#Picture                = Url
#Currency               = Currency
#Enterprise Keywords    = Enterprise Keywords


$columns = Import-Csv -Path 'C:\Users\mikek\Desktop\ColumnParameters(clean).csv'

foreach ($column in $columns) {
    
    $fieldparams = @{
        'List' = $column.List; 
        'DisplayName' = $column.DisplayName ;
        'InternalName' = ($column.DisplayName -replace '\s', '') ;
        'Type' = $column.Type ;
        'AddToDefaultView' = [System.Convert]::ToBoolean($column.AddToDefaultView) ;
        'Required' = [System.Convert]::ToBoolean($column.Required) ;
    }#end parameters
    
    Add-PnPField @fieldparams

}#end foreach


if (!$column) {
 
}


param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Args
)

# aria2c with 16 connections, 16 splits, 1M segment size
aria2c -x 16 -s 16 -k 1M @Args
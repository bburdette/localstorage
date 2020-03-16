port module LocalStorage exposing (clearLocalStorage, getLocalVal, localVal, storeLocalVal)


port storeLocalVal : ( String, String ) -> Cmd msg


port getLocalVal : ( String, String ) -> Cmd msg


port clearLocalStorage : () -> Cmd msg


port localVal : (( String, String, Maybe String ) -> msg) -> Sub msg

import ballerina/http;
import ballerina/io;

service / on new http:Listener(8090) {
    resource function get .(
        string name,
        @http:Header string internalHost,
        @http:Header string resourcePath
    ) returns json|error {
        return sayGreetings(name, internalHost, resourcePath);
    }
}

public function sayGreetings(string name, string apiKey, string host, string resourcePath) returns json|error {
    // Creates a new client with the Basic REST service URL.
    http:Client greetingClient = check new (string `https://${host}`);
        // {
        //     secureSocket: { 
        //         enable: true
        //     }
        // }
        

    // Sends a `GET` request to the "/albums" resource.
    // The verb is not mandatory as it is default to "GET".
    //map<string> additionalHeaders = {
    //    "API-Key" : apiKey
    //};
    string path = resourcePath + string `?name=${name}`;
    json|error response = greetingClient->get(path);
    if response is error {
        io:println("GET request error:" + response.detail().toString());
    } else {
        io:println("GET request:" + response.toJsonString());
    }

    return response;
}

package main

import (
    "fmt"
    "log"
    "net/http"
	"encoding/json"
	"io/ioutil"
    "github.com/gorilla/mux"
)

var events []interface{} 

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/event", createEvent).Methods("POST")
	router.HandleFunc("/events", getAllEvents).Methods("GET")
	router.PathPrefix("/").Handler(http.FileServer(http.Dir("./")))
	fmt.Println("Listening on localhost:3000")
	log.Fatal(http.ListenAndServe("localhost:3000", router))
}

func createEvent(w http.ResponseWriter, r *http.Request){
	var event map[string]interface{}
	fmt.Println("in CreateEvent")
	reqBody, _ := ioutil.ReadAll(r.Body)
	json.Unmarshal(reqBody, &event)
	str := fmt.Sprintf("%v", event)
	fmt.Println(str)
	events = append(events, event)
	json.NewEncoder(w).Encode(events)
}

func getAllEvents(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Events received from Upscale: " )
	json.NewEncoder(w).Encode(events)
}

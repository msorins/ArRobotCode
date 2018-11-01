package main

import (
	"API"
	"Entities"
	"Repository"
)

func main() {
	var cbr Repository.IRepository
	cbr = Repository.CouchBaseRepositoryBuilder("levels")

	tiles := []Entities.Tile{ Entities.Tile{Type:0}, Entities.Tile{Type:0}, Entities.Tile{Type:1}, Entities.Tile{Type:2}}
	level := Entities.Level{ Name: "HardLevel", Width: 15, Height: 15, Tiles: tiles}
	cbr.AddLevel(level)
	level = Entities.Level{ Name: "UltraHardLevel", Width: 25, Height: 25, Tiles: tiles}
	cbr.AddLevel(level)

	// Start the API
	api := API.APIBuilder("", ":8000", cbr)
	api.StartServer()
}

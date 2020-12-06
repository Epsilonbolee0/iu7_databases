package main

import (
	"gorm.io/gorm"
	"gorm.io/driver/postgres"
	"fmt"
)

type JSON json.RawMessage

type Tasks struct {
	gorm.Model
	id uint16
	homework_id uint16
	theme_code uint8
	author_id uint8
	data string
	solution string
	publication_date string
	rating uint8,
	doc JSON
}

type Doctype struct {
	author string
	book   string
	difficulty int
	picture string
}


type DatabaseFacade struct {
	db *gorm.DB
}

func (facade_ *DatabaseFacade) init(user string, password string, port uint16) bool {
	dsn := fmt.Sprintf("user=%s password=%s dbname=educational_site port=%d sslmode=disable TimeZone=Asia/Shanghai", user, password, port)
	temp, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if (err == nil) {
		facade_.db = temp
		facade_.db.AutoMigrate(&Tasks{})
	}
	return err == nil
}

type JSON json.RawMessage

func (j *JSON) Scan(value interface{}) error {
  bytes, ok := value.([]byte)
  if !ok {
    return errors.New(fmt.Sprint("Failed to unmarshal JSONB value:", value))
  }

  result := json.RawMessage{}
  err := json.Unmarshal(bytes, &result)
  *j = JSON(result)
  return err
}

func (j JSON) Value() (driver.Value, error) {
  if len(j) == 0 {
    return nil, nil
  }
  return json.RawMessage(j).MarshalJSON()
}

// Получить автора
func (facade_ *DatabaseFacade) readJSON(id_ uint16) string {
	var doc JSON
	var res

	facade_.db.Table("tasks").Select("doc").Where("id = ?", id_).First().Scan(&doc)

	Select("author", doc).Scan(&value)
	return doc["author"]
}

// Обновление картинки из JSON
func (facade_ *DatabaseFacade) readJSON(id_ uint16) {
	var doc JSON
	var res

	facade_.db.Table("tasks").Select("doc").Where("id = ?", id_).Scan(&doc)
	doc.Delete("? picture")
	facade_.db.Table("tasks").Update("doc").Where("doc", doc)
}

// Добавление значения value
func (facade_ *DatabaseFacade) readJSON(id_ uint16) {
	var doc JSON
	var res

	facade_.db.Table("tasks").Select("doc").Where("id = ?", id_).Scan(&doc)
	doc.Create({value:3})
	facade_.db.Table("tasks").Update("doc").Where("doc", doc)
}

func main () {
	var facade_ DatabaseFacade;
	facade_.init("postgres", "1029384756tnn_", 5432)
	
	fmt.Print(facade_.singleTable(28))
}
	


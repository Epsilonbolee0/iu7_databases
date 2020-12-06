package main

import (
	"gorm.io/gorm"
	"gorm.io/driver/postgres"
	"fmt"
)

type Theme struct {
	gorm.Model
	subject_code, code uint8
	name string
}

type Subject struct {
	gorm.Model
	code uint8
	name string
}


type DatabaseFacade struct {
	db *gorm.DB
}

func (facade_ *DatabaseFacade) init(user string, password string, port uint16) bool {
	dsn := fmt.Sprintf("user=%s password=%s dbname=educational_site port=%d sslmode=disable TimeZone=Asia/Shanghai", user, password, port)
	temp, err := gorm.Open(postgres.Open(dsn), &gorm.Config{})
	if (err == nil) {
		facade_.db = temp
		facade_.db.AutoMigrate(&Subject{})
		facade_.db.AutoMigrate(&Theme{})
	}
	return err == nil
}

// Все темы (Однотабличный запрос)
func (facade_ *DatabaseFacade) singleTable(subject_code_ uint8) []uint8 {
	var themes []Theme;

	facade_.db.Where("subject_code = ?", subject_code_).Find(&themes)

	return themes
} 

// Пары название предмета - тема
type Pair struct {
	subject_name string
	name string
}

func (facade_ *DatabaseFacade) someTables() []Pair {
	var result []Pair
	var themes []Theme
	var subjects []Subject

	facade_.db.Table("subjects")Select("subjects.name", "themes.name"
	).Join("JOIN themes ON themes.subject_code = subjects.code"
	).Scan(&result)

	return result
}

// Добавление предмета
func (facade_ *DatabaseFacade) addSubject(subject_code uint8, name string) {
	facade_.db.Create(&Subject{subject_code, name})
}

// Удаление темы
func (facade_ *DatabaseFacade) dropTheme(subject_code uint8) {
	facade_.db.Delete(Theme{}, "subject_code = ?", subject_code)
} 

// Обновление темы
func (facade_ *DatabaseFacade) dropTheme(prev_code uint8, new_code uint8) {
	facade_.Model(&Theme{}).db.Where(Theme{}, "code = ?", prev_code).Update("code", new_code)
} 

// Процедура, возвращающая количество преподавателей
func (facade_ *DatabaseFacade) getTeacherCnt() uint64 {
	return facade_.db.Select("count").From("get_teacher_number()")
}


func main () {
	var facade_ DatabaseFacade;
	facade_.init("postgres", "1", 5432)
	
	fmt.Print(facade_.singleTable(28))
}
	 


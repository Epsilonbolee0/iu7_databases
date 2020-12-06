package main

import (
	"github.com/ahmetb/go-linq"
	"fmt"
)

type Theme struct {
	subject_code, code uint8
	name string
}

type Themes struct {
	values []Theme 
}


func (t *Themes) init() {
	t.values = append(t.values, Theme{1, 11, "Anime in history"})
	t.values = append(t.values, Theme{1, 12, "Ecchi and its cultural value"})
	t.values = append(t.values, Theme{1, 13, "Speaking about Evangelion for the last time"})
	t.values = append(t.values, Theme{2, 21, "The best throw in history of sambo"})
	t.values = append(t.values, Theme{2, 22, "Tatar belt fighting vs sambo"})
	t.values = append(t.values, Theme{3, 31, "When will we be eaten by worms?"})
}

// Получение темы по предмету
func (themes *Themes) themesBySubject(subject_code_ uint8) []uint8 {
	var codes_ []uint8

	linq.From(themes.values).WhereT(func(t Theme) bool {
			return t.subject_code == subject_code_
	}).SelectT(func(t Theme) uint8 {
			return t.code
	}).ToSlice(&codes_)

	return codes_
}

// Самый непопулярный предмет (меньше всего тем)
func (themes *Themes) leastThemesSubject() uint8 {
	interface_ :=  
		linq.From(themes.values).Select(
			func(theme interface{}) interface{} {
				return theme.(Theme).subject_code
		}).GroupBy(
			func(subject_code interface{}) interface{} {
				return subject_code
			},
			func(subject_code interface{}) interface{} {
				return subject_code
		}).OrderBy(
			func(group interface{}) interface{} {
				return len(group.(linq.Group).Group)
		}).Select(
			func(group interface{}) interface{} {
				return group.(linq.Group).Key
		}).First()


	code_, _ := interface_.(uint8)
	return code_
}

// Найти тему с самым длинным названием внутри предмета
func (themes *Themes) longestName(subject_code_ uint8) string {
	interface_ := 
		linq.From(themes.values).Aggregate(
			func (theme interface{}, champ interface{}) interface{} {
				if (len(theme.(Theme).name) > len(champ.(Theme).name)) {
					return theme
				}
				return champ
		})

	name, _ := interface_.(Theme)
	return name.name
}


// Найти всевозможные пары тем
func (themes *Themes) themePairs(subject_code_ uint8) []string {
	var themes_ []string

	linq.From(themes.values).WhereT(
			func(t Theme) bool {
				return t.subject_code == subject_code_
		}).JoinT(
			linq.From(themes.values).WhereT(
				func(t Theme) bool {
				return t.subject_code == subject_code_
			}), 
				    func(theme Theme) uint8 { return theme.code / 10},
				    func(theme Theme) uint8 { return theme.code / 10},
				    func(outer Theme, inner Theme) string {
						return fmt.Sprintf("%s - %s", outer.code, inner.code)
		}).ToSlice(&themes_)

	return themes_
}

// Проверка существования темы
func (themes *Themes) containsTheme(code_ uint8) bool {
	exists := 
		linq.From(themes.values).Select(
			func(theme interface{}) interface{} {
				return theme.(Theme).code
		}).Contains(code_)

	return exists
}

func main() {
	var base Themes

	base.init()
	fmt.Printf(" Themes by subjects:\n")
	for _, theme_ := range base.themesBySubject(1) {
		fmt.Printf("%d\n", theme_)
	}

	fmt.Printf(" Subjects with least themes:\n")
	fmt.Printf(" %d\n", base.leastThemesSubject())

	fmt.Printf(" Longest name in anime:\n")
	fmt.Printf(" %s\n", base.longestName(1))

	fmt.Printf(" All the theme pairs:\n")
	fmt.Printf(" %s\n", base.themePairs(1))

	fmt.Printf(" Does it contain:\n")
	fmt.Printf(" %s\n", base.containsTheme(21))
}


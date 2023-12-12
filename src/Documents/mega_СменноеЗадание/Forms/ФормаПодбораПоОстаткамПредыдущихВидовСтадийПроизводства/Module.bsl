#Область ОписаниеПеременных

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПроизводственныйРесурс = Параметры.ПроизводственныйРесурс;
	ИнициализацияТаблицыСостав();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы //<ИмяТаблицыФормы>

// Код процедур и функций

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСтроку(Команда)
	
	ТекущиеДанные = Элементы.Состав.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Номенклатура,
		|Спецификация,
		|ВидСтадииОбработки,
		|Количество");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		Структура.Количество = ТекущиеДанные.Доступно;
		
		ОповеститьОВыборе(Структура);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ИнициализацияТаблицыВидовСтадийТекущегоПроизводственногоРесурса()
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТехнологическиеОперации.Ссылка КАК Спецификация,
		|	ТехнологическиеОперации.КлючСвязи
		|ПОМЕСТИТЬ втОперацииПроизводственногоРесурса
		|ИЗ
		|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК ТехнологическиеОперации
		|ГДЕ
		|	ТехнологическиеОперации.Номенклатура.ПроизводственныйРесурс = &ПроизводственныйРесурс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	втОперацииПроизводственногоРесурса.Спецификация,
		|	СтадииОбработки.ВидСтадииОбработки
		|ИЗ
		|	втОперацииПроизводственногоРесурса КАК втОперацииПроизводственногоРесурса
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.mega_Спецификации.СтадииОбработки КАК СтадииОбработки
		|		ПО втОперацииПроизводственногоРесурса.Спецификация = СтадииОбработки.Ссылка
		|		И втОперацииПроизводственногоРесурса.КлючСвязи = СтадииОбработки.КлючСвязи
		|СГРУППИРОВАТЬ ПО
		|	втОперацииПроизводственногоРесурса.Спецификация,
		|	СтадииОбработки.ВидСтадииОбработки";
	
	Запрос.УстановитьПараметр("ПроизводственныйРесурс", ПроизводственныйРесурс);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Возврат ВыборкаДетальныеЗаписи;	
КонецФункции

&НаСервере
Функция ИнициализацияТаблицыДляПолученияОстатков(ВыборкаДетальныеЗаписи)
	
			
	ТаблицаДляПолученияОстатков = Новый ТаблицаЗначений();
	
	Типы = Новый Массив;
	Типы.Добавить(Тип("СправочникСсылка.mega_ВидыСтадийОбработки"));
	ОписаниеТипов = Новый ОписаниеТипов(Типы);
	ТаблицаДляПолученияОстатков.Колонки.Добавить("ВидСтадииОбработки", ОписаниеТипов);
	
	Типы = Новый Массив;
	Типы.Добавить(Тип("СправочникСсылка.mega_Спецификации"));
	ОписаниеТипов = Новый ОписаниеТипов(Типы);
	ТаблицаДляПолученияОстатков.Колонки.Добавить("Спецификация", ОписаниеТипов);
	
	ТаблицаДляПолученияОстатков.Очистить();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ТекущаяСтадияОбработки = Справочники.mega_Спецификации.ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(
			ВыборкаДетальныеЗаписи.Спецификация, 
			ВыборкаДетальныеЗаписи.ВидСтадииОбработки);
		ПредыдущаяСтадияОбработки = Справочники.mega_Спецификации.ПолучитьПредыдущуюСтадиюОбработки(
			ВыборкаДетальныеЗаписи.Спецификация, ТекущаяСтадияОбработки);
		НоваяСтрока = ТаблицаДляПолученияОстатков.Добавить();
		НоваяСтрока.Спецификация = ВыборкаДетальныеЗаписи.Спецификация;
		НоваяСтрока.ВидСтадииОбработки = ПредыдущаяСтадияОбработки.ВидСтадииОбработки; 
	КонецЦикла;
	
	Возврат ТаблицаДляПолученияОстатков;
КонецФункции

&НаСервере
Функция ТаблицаОстатков(ТаблицаДляПолученияОстатков)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТаблицаДляПолученияОстатков.Спецификация,
		|	ТаблицаДляПолученияОстатков.ВидСтадииОбработки
		|ПОМЕСТИТЬ втТаблицаДляПолученияОстатков
		|ИЗ
		|	&ТаблицаДляПолученияОстатков КАК ТаблицаДляПолученияОстатков
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	втТаблицаДляПолученияОстатков.Спецификация.Владелец КАК Номенклатура,
		|	втТаблицаДляПолученияОстатков.Спецификация.Владелец.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	втТаблицаДляПолученияОстатков.ВидСтадииОбработки,
		|	втТаблицаДляПолученияОстатков.Спецификация КАК Спецификация,
		|	ЕСТЬNULL(mega_СкладскиеЗапасыОстатки.КоличествоОстаток, 0) КАК НаСкладе,
		|	ЕСТЬNULL(mega_ПроизводственныеЗапасыОстатки.КоличествоОстаток, 0) КАК ВПроизводстве,
		|	ЕСТЬNULL(mega_ПроизводственныеЗапасыОстатки.КоличествоОстаток, 0) + ЕСТЬNULL(mega_СкладскиеЗапасыОстатки.КоличествоОстаток, 0) КАК Доступно
		|ИЗ
		|	втТаблицаДляПолученияОстатков КАК втТаблицаДляПолученияОстатков
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.mega_СкладскиеЗапасы.Остатки КАК mega_СкладскиеЗапасыОстатки
		|		ПО втТаблицаДляПолученияОстатков.Спецификация.Владелец = mega_СкладскиеЗапасыОстатки.Номенклатура
		|		И втТаблицаДляПолученияОстатков.ВидСтадииОбработки = mega_СкладскиеЗапасыОстатки.ВидСтадииОбработки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.mega_ПроизводственныеЗапасы.Остатки КАК mega_ПроизводственныеЗапасыОстатки
		|		ПО втТаблицаДляПолученияОстатков.Спецификация.Владелец = mega_ПроизводственныеЗапасыОстатки.Номенклатура
		|		И втТаблицаДляПолученияОстатков.ВидСтадииОбработки = mega_ПроизводственныеЗапасыОстатки.ВидСтадииОбработки";
	
	
	Запрос.УстановитьПараметр("ТаблицаДляПолученияОстатков", ТаблицаДляПолученияОстатков);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();	
	
	Возврат ВыборкаДетальныеЗаписи;
КонецФункции

&НаСервере
Процедура ЗаполнениеТаблицыСостав(ВыборкаОстатков)
	
	
	Состав.Очистить();
	Пока ВыборкаОстатков.Следующий() Цикл
		
		Если ВыборкаОстатков.Доступно <= 0 Тогда
			
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = Состав.Добавить();
		НоваяСтрока.Номенклатура = ВыборкаОстатков.Номенклатура;
		НоваяСтрока.ЕдиницаИзмерения = ВыборкаОстатков.ЕдиницаИзмерения;
		НоваяСтрока.ВидСтадииОбработки = ВыборкаОстатков.ВидСтадииОбработки;
		НоваяСтрока.Спецификация = ВыборкаОстатков.Спецификация;
		НоваяСтрока.НаСкладе = ВыборкаОстатков.НаСкладе;
		НоваяСтрока.ВПроизводстве = ВыборкаОстатков.ВПроизводстве;
		НоваяСтрока.Доступно = ВыборкаОстатков.Доступно;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ИнициализацияТаблицыСостав()
		
	ВыборкаДетальныеЗаписи = ИнициализацияТаблицыВидовСтадийТекущегоПроизводственногоРесурса();
	ТаблицаДляПолученияОстатков = ИнициализацияТаблицыДляПолученияОстатков(ВыборкаДетальныеЗаписи);
	ВыборкаОстатков = ТаблицаОстатков(ТаблицаДляПолученияОстатков);
	ЗаполнениеТаблицыСостав(ВыборкаОстатков);			
КонецПроцедуры


#КонецОбласти

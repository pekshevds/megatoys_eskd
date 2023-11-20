///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	
	ТекущиеДанные = Элементы.СтадииОбработки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 		
		
		ТекущаяСтадияОбработки = ТекущиеДанные.КлючСвязи;
		
		УстановитьОтборСтрокМатериалы();
		УстановитьОтборСтрокТехнологическиеОперации();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
#КонецОбласти



#Область ОбработчикиСобытийЭлементовТаблицыФормыСтадииОбработки

&НаКлиенте
Процедура СтадииОбработкиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.СтадииОбработки.ТекущиеДанные;
		ТекущиеДанные.КлючСвязи = Новый УникальныйИдентификатор();
		ТекущиеДанные.Количество = 1;
		
		ТекущаяСтадияОбработки = ТекущиеДанные.КлючСвязи;
	КонецЕсли;
		
	УстановитьОтборСтрокМатериалы();
	УстановитьОтборСтрокТехнологическиеОперации();
КонецПроцедуры

&НаКлиенте
Процедура СтадииОбработкиПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.СтадииОбработки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		ТекущаяСтадияОбработки = ТекущиеДанные.КлючСвязи;	
	КонецЕсли;  
	
	УстановитьОтборСтрокМатериалы();
	УстановитьОтборСтрокТехнологическиеОперации();
КонецПроцедуры

&НаКлиенте
Процедура СтадииОбработкиПередУдалением(Элемент, Отказ)
	
	Отказ = Не МожноУдалитьСтрокуСтадииОбработки();
КонецПроцедуры  

#КонецОбласти




#Область ОбработчикиСобытийЭлементовТаблицыФормыМатериалы

&НаКлиенте
Процедура МатериалыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ ЗначениеЗаполнено(ТекущаяСтадияОбработки) Тогда 
		
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	 Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда 
			
			ТекущиеДанные.КлючСвязи = ТекущаяСтадияОбработки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		СтруктураРеквизитов = Новый Структура("Номенклатура,ЕдиницаИзмерения,Спецификация,СтадияОбработки,Количество");
		
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, ТекущиеДанные);
		ЗаполнитьРеквизитыСтрокиНаСервере(СтруктураРеквизитов);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтруктураРеквизитов);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТехнологическиеОперации

&НаКлиенте
Процедура ТехнологическиеОперацииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ ЗначениеЗаполнено(ТекущаяСтадияОбработки) Тогда 
		
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		СтруктураРеквизитов = Новый Структура("Номенклатура,ЕдиницаИзмерения,Количество");
		
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, ТекущиеДанные);
		ЗаполнитьРеквизитыСтрокиНаСервере(СтруктураРеквизитов);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтруктураРеквизитов);
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ТехнологическиеОперацииНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.СтадииОбработки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ВидСтадииОбработки = ТекущиеДанные.ВидСтадииОбработки;
		Если ЗначениеЗаполнено(ВидСтадииОбработки) Тогда			
			
			
			ТехОперации = Новый СписокЗначений(); 
			ТехОперации.ЗагрузитьЗначения(
				ПолучитьДоступныеТехнологическиеОперацииНаСервере(ВидСтадииОбработки));
			ДанныеВыбора = ТехОперации;
			
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;		
		Если ТекущиеДанные <> Неопределено Тогда
			
			ТекущиеДанные.КлючСвязи = ТекущаяСтадияОбработки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборСтрокМатериалы()
	
	Элементы.Материалы.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСвязи", ТекущаяСтадияОбработки);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСтрокТехнологическиеОперации()
	
	Элементы.ТехнологическиеОперации.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСвязи", ТекущаяСтадияОбработки);
КонецПроцедуры

&НаСервере
Функция ПолучитьДоступныеТехнологическиеОперацииНаСервере(ВидСтадииОбработки)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	mega_Номенклатура.Ссылка
		|ИЗ
		|	Справочник.mega_Номенклатура КАК mega_Номенклатура
		|ГДЕ
		|	mega_Номенклатура.ПроизводственныйРесурс В
		|		(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|			mega_ВидыСтадийОбработкиПроизводственныеРесурсы.ПроизводственныйРесурс
		|		ИЗ
		|			Справочник.mega_ВидыСтадийОбработки.ПроизводственныеРесурсы КАК mega_ВидыСтадийОбработкиПроизводственныеРесурсы
		|		ГДЕ
		|			mega_ВидыСтадийОбработкиПроизводственныеРесурсы.Ссылка = &ВидСтадииОбработки)";
	
	Запрос.УстановитьПараметр("ВидСтадииОбработки", ВидСтадииОбработки);
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");		
КонецФункции

&НаСервере
Функция МожноУдалитьСтрокуСтадииОбработки()
	
	Если Не ЗначениеЗаполнено(ТекущаяСтадияОбработки) Тогда 
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Объект.Материалы.НайтиСтроки(Новый Структура("КлючСвязи", ТекущаяСтадияОбработки)).Количество() = 0 И 
			Объект.ТехнологическиеОперации.НайтиСтроки(Новый Структура("КлючСвязи", ТекущаяСтадияОбработки)).Количество() = 0;
КонецФункции

&НаСервере
Процедура ЗаполнитьРеквизитыСтрокиНаСервере(СтруктураРеквизитов)
	
	Если ЗначениеЗаполнено(СтруктураРеквизитов.Номенклатура) Тогда 
		
		Если СтруктураРеквизитов.Свойство("ЕдиницаИзмерения") Тогда 
			
			СтруктураРеквизитов.ЕдиницаИзмерения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураРеквизитов.Номенклатура, "ЕдиницаИзмерения");
		КонецЕсли;
		
		Если СтруктураРеквизитов.Свойство("Спецификация") Тогда 
			
			СтруктураРеквизитов.Спецификация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураРеквизитов.Номенклатура, "Спецификация");
			Если СтруктураРеквизитов.Свойство("СтадияОбработки") И ЗначениеЗаполнено(СтруктураРеквизитов.Спецификация) Тогда
				СтруктураРеквизитов.СтадияОбработки = 
					Справочники.mega_Спецификации.ПолучитьПоследнююСтадиюОбработки(СтруктураРеквизитов.Спецификация).ВидСтадииОбработки;
			КонецЕсли;			
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
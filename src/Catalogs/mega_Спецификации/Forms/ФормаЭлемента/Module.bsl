&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	
	ТекущиеДанные = Элементы.СтадииОбработки.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 		
		
		ТекущаяСтадияОбработки = ТекущиеДанные.КлючСвязи;
		
		УстановитьОтборСтрокМатериалы();
		УстановитьОтборСтрокТехнологическиеОперации();
	КонецЕсли;
	
КонецПроцедуры

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
Процедура МатериалыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ ЗначениеЗаполнено(ТекущаяСтадияОбработки) Тогда 
		
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Если НЕ ЗначениеЗаполнено(ТекущаяСтадияОбработки) Тогда 
		
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСтрокМатериалы()
	
	Элементы.Материалы.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСвязи", ТекущаяСтадияОбработки);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСтрокТехнологическиеОперации()
	
	Элементы.ТехнологическиеОперации.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСвязи", ТекущаяСтадияОбработки);
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
Процедура ТехнологическиеОперацииПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;		
		Если ТекущиеДанные <> Неопределено Тогда
			
			ТекущиеДанные.КлючСвязи = ТекущаяСтадияОбработки;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура СтадииОбработкиПередУдалением(Элемент, Отказ)
	
	Отказ = Не МожноУдалитьСтрокуСтадииОбработки();
КонецПроцедуры  

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
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		СтруктураРеквизитов = Новый Структура("Номенклатура,ЕдиницаИзмерения,Спецификация,Количество");
		
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, ТекущиеДанные);
		ЗаполнитьРеквизитыСтрокиНаСервере(СтруктураРеквизитов);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, СтруктураРеквизитов);
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

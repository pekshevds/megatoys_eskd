#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИспользоватьКакОсновную(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыСообщения = Новый Структура;
	ПараметрыСообщения.Вставить("Спецификация", Элементы.Список.ТекущиеДанные.Ссылка);
	ПараметрыСообщения.Вставить("Номенклатура", Элементы.Список.ТекущиеДанные.Владелец);
	
	Если ЕстьВладелецВОтборе() Тогда
		
		
		Модифицированность = Ложь;
		Оповестить("НазначенаПоКнопкеОсновнаяСпецификацияВСпискеСпецификаций", ПараметрыСообщения);
	Иначе
		
		УстановитьОсновнуюСпецификациюНаСервере(ПараметрыСообщения);				
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ЕстьВладелецВОтборе()
	
	ПолеКомпоновкиДанныхВладелец = Новый ПолеКомпоновкиДанных("Владелец");
	Для Каждого Элемент Из Список.Отбор.Элементы Цикл
		
		Если Элемент.ЛевоеЗначение = ПолеКомпоновкиДанныхВладелец Тогда 
			
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	Возврат Ложь;
КонецФункции

&НаСервере
Процедура УстановитьОсновнуюСпецификациюНаСервере(Параметры)

	Попытка
		
		Номенклатура = Параметры.Номенклатура.ПолучитьОбъект();
		Номенклатура.Спецификация = Параметры.Спецификация;
		Номенклатура.Записать();		
	Исключение
		
		ОбщегоНазначения.СообщитьПользователю("Ошибка установки основной спецификации");
	КонецПопытки;		
КонецПроцедуры

#КонецОбласти

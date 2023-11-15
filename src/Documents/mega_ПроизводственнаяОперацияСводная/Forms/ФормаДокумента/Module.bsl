///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
		МодульПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды 
		
КонецПроцедуры   

&НаКлиенте
Процедура ПриОткрытии(Отказ)  
	
	УправлениеДоступностью();
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 		
		
		ТекущаяТехнологическаяОперация = ТекущиеДанные.КлючСвязи;
		
		УстановитьОтборСтрокМатериалы();		
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
		МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ПодключаемыеКоманды") Тогда
		МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
		МодульПодключаемыеКомандыКлиент.ПослеЗаписи(ЭтотОбъект, Объект, ПараметрыЗаписи);
	КонецЕсли;
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
	
&НаКлиенте
Процедура ПодразделениеПриИзменении(Элемент)
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НачалоСменыПриИзменении(Элемент)
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ОкончаниеСменыПриИзменении(Элемент)
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры



#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТехнологическиеОперации

&НаКлиенте
Процедура ТехнологическиеОперацииТехнологическаяОперацияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Спецификация = ТекущиеДанные.Спецификация;
		Если ЗначениеЗаполнено(Спецификация) Тогда			
			
			ВидСтадииОбработки = ТекущиеДанные.ВидСтадииОбработки;
			
			ТехОперации = Новый СписокЗначений(); 
			ТехОперации.ЗагрузитьЗначения(
				ПолучитьДоступныеТехнологическиеОперацииНаСервере(Спецификация, ВидСтадииОбработки));
			ДанныеВыбора = ТехОперации;
			
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПриИзменении(Элемент)
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииВидСтадииОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Спецификация = ТекущиеДанные.Спецификация;
		Если ЗначениеЗаполнено(Спецификация) Тогда			
	
			ВидыСтадийОбработки = Новый СписокЗначений(); 
			//ВидыСтадийОбработки.ЗагрузитьЗначения(ПолучитьДоступныеВидыСтадийОбработкиНаСервере(Спецификация));
			ВидыСтадийОбработки.ЗагрузитьЗначения(
				ПолучитьДоступныеВидыСтадийОбработкиПоПроизводственномуРесурсуНаСервере(Спецификация, Объект.ПроизводственныйРесурс));			
			
			ДанныеВыбора = ВидыСтадийОбработки;
			
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПередУдалением(Элемент, Отказ)
	
	Отказ = Не МожноУдалитьСтрокуТехнологическойОперации();
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
		ТекущиеДанные.КлючСвязи = Новый УникальныйИдентификатор();
		ТекущиеДанные.Количество = 1;
		
		ТекущаяТехнологическаяОперация = ТекущиеДанные.КлючСвязи;
	КонецЕсли;
	
	УстановитьОтборСтрокМатериалы();
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		ТекущаяТехнологическаяОперация = ТекущиеДанные.КлючСвязи;	
	КонецЕсли;
	
	УстановитьОтборСтрокМатериалы();
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПредыдущийВидСтадииОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Спецификация = ТекущиеДанные.Спецификация;
		Если ЗначениеЗаполнено(Спецификация) Тогда			
	
			ВидыСтадийОбработки = Новый СписокЗначений(); 
			ВидыСтадийОбработки.ЗагрузитьЗначения(ПолучитьДоступныеВидыСтадийОбработкиНаСервере(Спецификация));
			ДанныеВыбора = ВидыСтадийОбработки;
			
			СтандартнаяОбработка = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииКоличествоПриИзменении(Элемент)
	
	ТехнологическиеОперацииКоличествоПриИзмененииНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииНоменклатураПриИзменении(Элемент)
	
	ТехнологическиеОперацииНоменклатураПриИзмененииНаКлиенте();	
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПредыдущийВидСтадииОбработкиПриИзменении(Элемент)
	
	ТехнологическиеОперацииПредыдущийВидСтадииОбработкиПриИзмененииНаКлиенте();	
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииВидСтадииОбработкиПриИзменении(Элемент)
	
	ТехнологическиеОперацииВидСтадииОбработкиПриИзмененииНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзменении(Элемент)
	
	ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзмененииНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииТехнологическаяОперацияКоэффициентыСложностиПриИзменении(Элемент)
	
	ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзмененииНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииТехнологическаяОперацияПриИзменении(Элемент)
	
	ТехнологическиеОперацииТехнологическаяОперацияПриИзмененииНаКлиенте();		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМатериалыОпераций

&НаКлиенте
Процедура МатериалыОперацийНоменклатураПриИзменении(Элемент)
	
	МатериалыОперацийНоменклатураПриИзмененииНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура МатериалыОперацийКоличествоПриИзменении(Элемент)

	МатериалыОперацийКоличествоПриИзмененииНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура МатериалыОперацийПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если НоваяСтрока Тогда
		
		ТекущиеДанные = Элементы.МатериалыОпераций.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда 
			
			ТекущиеДанные.КлючСвязи = ТекущаяТехнологическаяОперация;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура МатериалыОперацийПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа, Параметр)
	
	Если НЕ ЗначениеЗаполнено(ТекущаяТехнологическаяОперация) Тогда 
		
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура МатериалыОперацийПриИзменении(Элемент)
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыМатериалы

&НаКлиенте
Процедура МатериалыНоменклатураПриИзменении(Элемент)
	
	МатериалыНоменклатураПриИзмененииНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура МатериалыКоличествоПриИзменении(Элемент)

	МатериалыКоличествоПриИзмененииНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура МатериалыПриИзменении(Элемент)
	
	ЗаполнитьОстаткиНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаполнитьМатериалы(Команда)

	Если Объект.МатериалыОпераций.Количество() = 0 Тогда
		
		ЗаполнитьМатериалыПоМатериаламОперацийНаСервере();
	Иначе
		Режим = РежимДиалогаВопрос.ДаНет;
		
		ОписаниеОповещенияОЗавершении = 
			Новый ОписаниеОповещения("ПослеЗакрытияВопросаООчисткеТаблицыМатериалов", ЭтотОбъект);	
		
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, 
			НСтр("ru = 'Перед заполнением табличная часть будет очищена. Продолжить?';"), Режим, 0);		
	КонецЕсли;	

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьМатериалыОпераций(Команда)
	
	Если Объект.МатериалыОпераций.Количество() = 0 Тогда
		
		ЗаполнитьМатериалыПоСпецификацииНаСервере();
	Иначе
		Режим = РежимДиалогаВопрос.ДаНет;
		
		ОписаниеОповещенияОЗавершении = 
			Новый ОписаниеОповещения("ПослеЗакрытияВопросаООчисткеТаблицыМатериаловОпераций", ЭтотОбъект);	
		
		ПоказатьВопрос(ОписаниеОповещенияОЗавершении, 
			НСтр("ru = 'Перед заполнением табличная часть будет очищена. Продолжить?';"), Режим, 0);		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Получить материалы для получения остатков. Номенклатура из Матриалы и МатериалыОпераций
// 
// Возвращаемое значение:
//  Массив из СправочникСсылка.mega_Номенклатура - Материалы для получения остатков
&НаСервере
Функция ПолучитьМатериалыДляПолученияОстатков()
	Материалы = Объект.МатериалыОпераций.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
	Для Каждого Элемент Из Объект.Материалы.Выгрузить().ВыгрузитьКолонку("Номенклатура") Цикл
		
		Если Материалы.Найти(Элемент) = Неопределено Тогда
			
			Материалы.Добавить(Элемент);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Материалы;
КонецФункции

&НаСервере
Процедура ЗаполнитьОстаткиНаСервере()
	
	ГотоваяПродукция = Объект.ТехнологическиеОперации.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	Материалы = ПолучитьМатериалыДляПолученияОстатков();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПроизводственныеЗапасыОстатки.Номенклатура,
		|	ПроизводственныеЗапасыОстатки.ВидСтадииОбработки,
		|	ПроизводственныеЗапасыОстатки.КоличествоОстаток КАК Остаток
		|ИЗ
		|	РегистрНакопления.mega_ПроизводственныеЗапасы.Остатки(&НачалоСмены, Номенклатура В (&ГотоваяПродукция)
		|	И Подразделение = &Подразделение) КАК ПроизводственныеЗапасыОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПроизводственныеЗапасыОстатки.Номенклатура,
		|	ПроизводственныеЗапасыОстатки.ВидСтадииОбработки,
		|	ПроизводственныеЗапасыОстатки.КоличествоОстаток КАК Остаток
		|ИЗ
		|	РегистрНакопления.mega_ПроизводственныеЗапасы.Остатки(&ОкончаниеСмены, Номенклатура В (&ГотоваяПродукция)
		|	И Подразделение = &Подразделение) КАК ПроизводственныеЗапасыОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПроизводственныеЗапасыОстатки.Номенклатура,
		|	ПроизводственныеЗапасыОстатки.ВидСтадииОбработки,
		|	ПроизводственныеЗапасыОстатки.КоличествоОстаток КАК Остаток
		|ИЗ
		|	РегистрНакопления.mega_ПроизводственныеЗапасы.Остатки(&НачалоСмены, Номенклатура В (&Материалы)
		|	И Подразделение = &Подразделение) КАК ПроизводственныеЗапасыОстатки";
	
	Запрос.УстановитьПараметр("ГотоваяПродукция", ГотоваяПродукция);
	Запрос.УстановитьПараметр("Материалы", Материалы);
	Запрос.УстановитьПараметр("Подразделение", Объект.Подразделение);
	Запрос.УстановитьПараметр("НачалоСмены", Объект.НачалоСмены);
	Запрос.УстановитьПараметр("ОкончаниеСмены", Объект.ОкончаниеСмены);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаДетальныеЗаписиНачалоСмены = РезультатыЗапроса[0].Выбрать();
	ВыборкаДетальныеЗаписиОкончаниеСмены = РезультатыЗапроса[1].Выбрать();
	ВыборкаДетальныеЗаписиМатериалы = РезультатыЗапроса[2].Выбрать();
	
	Для Каждого ТекСтрокаСостав Из Объект.ТехнологическиеОперации Цикл
		
		Структура = Новый Структура;
		Структура.Вставить("Номенклатура", ТекСтрокаСостав.Номенклатура);
		Структура.Вставить("ВидСтадииОбработки", ТекСтрокаСостав.ВидСтадииОбработки);
		
		ТекСтрокаСостав.ОстатокНаНачалоСмены = 0;
		ВыборкаДетальныеЗаписиНачалоСмены.Сбросить();
		Если ВыборкаДетальныеЗаписиНачалоСмены.НайтиСледующий(Структура) Тогда
						
			ТекСтрокаСостав.ОстатокНаНачалоСмены = ВыборкаДетальныеЗаписиНачалоСмены.Остаток;
		КонецЕсли;
		
		ТекСтрокаСостав.ОстатокНаКонецСмены = 0;
		ВыборкаДетальныеЗаписиОкончаниеСмены.Сбросить();
		Если ВыборкаДетальныеЗаписиОкончаниеСмены.НайтиСледующий(Структура) Тогда
						
			ТекСтрокаСостав.ОстатокНаКонецСмены = ВыборкаДетальныеЗаписиОкончаниеСмены.Остаток;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого ТекСтрокаМатериалыОпераций Из Объект.МатериалыОпераций Цикл
		
		Структура = Новый Структура;
		Структура.Вставить("Номенклатура", ТекСтрокаМатериалыОпераций.Номенклатура);
		Структура.Вставить("ВидСтадииОбработки", ТекСтрокаМатериалыОпераций.ВидСтадииОбработки);
		
		ТекСтрокаМатериалыОпераций.ОстатокНаНачалоСмены = 0;
		ВыборкаДетальныеЗаписиМатериалы.Сбросить();
		Если ВыборкаДетальныеЗаписиМатериалы.НайтиСледующий(Структура) Тогда
						
			ТекСтрокаМатериалыОпераций.ОстатокНаНачалоСмены = ВыборкаДетальныеЗаписиМатериалы.Остаток;
		КонецЕсли;	
	КонецЦикла;
	
	Для Каждого ТекСтрокаМатериалы Из Объект.Материалы Цикл
		
		Структура = Новый Структура;
		Структура.Вставить("Номенклатура", ТекСтрокаМатериалы.Номенклатура);
		Структура.Вставить("ВидСтадииОбработки", ТекСтрокаМатериалы.ВидСтадииОбработки);
		
		ТекСтрокаМатериалы.ОстатокНаНачалоСмены = 0;
		ВыборкаДетальныеЗаписиМатериалы.Сбросить();
		Если ВыборкаДетальныеЗаписиМатериалы.НайтиСледующий(Структура) Тогда
						
			ТекСтрокаМатериалы.ОстатокНаНачалоСмены = ВыборкаДетальныеЗаписиМатериалы.Остаток;
		КонецЕсли;	
	КонецЦикла;
			
КонецПроцедуры

&НаКлиенте
Процедура МатериалыНоменклатураПриИзмененииНаКлиенте()
	
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Номенклатура,
		|Спецификация,
		|ЕдиницаИзмерения,
		|Количество,
		|Цена,
		|Сумма,
		|ДатаЦен");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		Структура.ДатаЦен = Объект.Дата;
		
		МатериалыНоменклатураПриИзмененииНаСервере(Структура);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура МатериалыНоменклатураПриИзмененииНаСервере(Структура)
	
	Структура.ЕдиницаИзмерения = Справочники.mega_ЕдиницыИзмерения.ПустаяСсылка();
	Структура.Спецификация = Справочники.mega_Спецификации.ПустаяСсылка();
	Структура.Количество = 0;
	Структура.Цена = 0;
	Структура.Сумма = 0;
		
	Если ЗначениеЗаполнено(Структура.Номенклатура) Тогда
		
		Структура.ЕдиницаИзмерения = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Структура.Номенклатура, "ЕдиницаИзмерения");		
		Структура.Спецификация = Справочники.mega_Спецификации.ПолучитьОсновнуюСпецификациюНоменклатуры(Структура.Номенклатура);
		
		Структура.Цена = РегистрыСведений.mega_ЦеныПлановойСебестоимости.ПолучитьПоследнююЦенуПлановойСебестоимости(
			Структура.Номенклатура, Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка(), Структура.ДатаЦен);
		Структура.Сумма = Структура.Цена * Структура.Количество; 
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыКоличествоПриИзмененииНаКлиенте()
	ТекущиеДанные = Элементы.Материалы.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Количество,
		|Цена,
		|Сумма");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);		
		МатериалыКоличествоПриИзмененииНаСервере(Структура);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура МатериалыКоличествоПриИзмененииНаСервере(Структура)
	
	Структура.Сумма = Структура.Цена * Структура.Количество; 
КонецПроцедуры

&НаКлиенте
Процедура МатериалыОперацийНоменклатураПриИзмененииНаКлиенте()
	
	ТекущиеДанные = Элементы.МатериалыОпераций.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Номенклатура,
		|Спецификация,
		|ЕдиницаИзмерения,
		|Количество,
		|Цена,
		|Сумма,
		|ДатаЦен");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		Структура.ДатаЦен = Объект.Дата;
		
		МатериалыОперацийНоменклатураПриИзмененииНаСервере(Структура);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура МатериалыОперацийНоменклатураПриИзмененииНаСервере(Структура)
	
	Структура.ЕдиницаИзмерения = Справочники.mega_ЕдиницыИзмерения.ПустаяСсылка();
	Структура.Спецификация = Справочники.mega_Спецификации.ПустаяСсылка();
	Структура.Количество = 0;
	Структура.Цена = 0;
	Структура.Сумма = 0;
		
	Если ЗначениеЗаполнено(Структура.Номенклатура) Тогда
		
		Структура.ЕдиницаИзмерения = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Структура.Номенклатура, "ЕдиницаИзмерения");		
		Структура.Спецификация = Справочники.mega_Спецификации.ПолучитьОсновнуюСпецификациюНоменклатуры(Структура.Номенклатура);
		
		Структура.Цена = РегистрыСведений.mega_ЦеныПлановойСебестоимости.ПолучитьПоследнююЦенуПлановойСебестоимости(
			Структура.Номенклатура, Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка(), Структура.ДатаЦен);
		Структура.Сумма = Структура.Цена * Структура.Количество; 
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура МатериалыОперацийКоличествоПриИзмененииНаКлиенте()
	ТекущиеДанные = Элементы.МатериалыОпераций.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Количество,
		|Цена,
		|Сумма");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);		
		МатериалыОперацийКоличествоПриИзмененииНаСервере(Структура);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура МатериалыОперацийКоличествоПриИзмененииНаСервере(Структура)
	
	Структура.Сумма = Структура.Цена * Структура.Количество; 
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииНоменклатураПриИзмененииНаКлиенте()
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Номенклатура,
		|Спецификация,
		|ЕдиницаИзмерения,
		|Количество,
		|Цена,
		|Сумма,
		|ВидСтадииОбработки,
		|ПредыдущийВидСтадииОбработки,
		|ТехнологическаяОперация,
		|ТехнологическаяОперацияЕдиницаИзмерения,
		|ТехнологическаяОперацияКоличество,		
		|ТехнологическаяОперацияЦена,
		|ТехнологическаяОперацияКоэффициентСложности,
		|ТехнологическаяОперацияСумма,
		|ДатаЦен");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		Структура.ДатаЦен = Объект.Дата;
		Структура.ТехнологическаяОперацияКоэффициентСложности = Объект.КоэффициентСложности;
		
		ТехнологическиеОперацииНоменклатураПриИзмененииНаСервере(Структура);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииКоличествоПриИзмененииНаКлиенте()
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"ТехнологическаяОперация,
		|Спецификация,
		|ВидСтадииОбработки,
		|ТехнологическаяОперацияКоличество,
		|Количество,
		|Цена,
		|Сумма,
		|ДатаЦен,
		|ТехнологическаяОперацияКоличество,
		|ТехнологическаяОперацияЦена,
		|ТехнологическаяОперацияКоэффициентСложности,
		|ТехнологическаяОперацияСумма");
		
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		Структура.ТехнологическаяОперацияКоэффициентСложности = Объект.КоэффициентСложности;
		Структура.ДатаЦен = Объект.Дата;

		ТехнологическиеОперацииКоличествоПриИзмененииНаСервере(Структура);				
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
		
		ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзмененииНаКлиенте();
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииПредыдущийВидСтадииОбработкиПриИзмененииНаКлиенте()
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"Номенклатура,
		|Количество,
		|Цена,
		|Сумма,
		|ПредыдущийВидСтадииОбработки,
		|ДатаЦен");
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		Структура.ДатаЦен = Объект.Дата;
		
		ТехнологическиеОперацииПредыдущийВидСтадииОбработкиПриИзмененииНаСервере(Структура);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииВидСтадииОбработкиПриИзмененииНаКлиенте()
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Спецификация = ТекущиеДанные.Спецификация;
		ВидСтадииОбработки = ТекущиеДанные.ВидСтадииОбработки;
		Если ЗначениеЗаполнено(Спецификация) Тогда			
			
			ТекущиеДанные.ТехнологическаяОперация = Неопределено;
			
			ТехОперации = ПолучитьДоступныеТехнологическиеОперацииНаСервере(Спецификация, ВидСтадииОбработки);
			Если ТехОперации.Количество() > 0 Тогда
				
				ТекущиеДанные.ТехнологическаяОперация = ТехОперации[0];
			КонецЕсли;
			
			ТехнологическиеОперацииТехнологическаяОперацияПриИзмененииНаКлиенте();
						
			Структура = Новый Структура;
			Структура.Вставить("Спецификация");
			Структура.Вставить("ВидСтадииОбработки");
			Структура.Вставить("ПредыдущийВидСтадииОбработки");
			
			ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);			
			ЗаполнитьПредыдущийВидСтадииОбработкиНаСервере(Структура);
			ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзмененииНаКлиенте()
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"ТехнологическаяОперация,
		|Спецификация,
		|ВидСтадииОбработки,
		|ТехнологическаяОперацияКоличество,
		|ТехнологическаяОперацияЦена,
		|ТехнологическаяОперацияКоэффициентСложности,
		|ТехнологическаяОперацияСумма,
		|ДатаЦен");
		
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		Структура.ДатаЦен = Объект.Дата;
		ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзмененииНаСервере(Структура);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТехнологическиеОперацииТехнологическаяОперацияПриИзмененииНаКлиенте()
	
	ТекущиеДанные = Элементы.ТехнологическиеОперации.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		Структура = Новый Структура(
		"ТехнологическаяОперация,
		|Спецификация,
		|ВидСтадииОбработки,
		|ПредыдущийВидСтадииОбработки,
		|Количество,
		|ДатаЦен,
		|ТехнологическаяОперацияЕдиницаИзмерения,
		|ТехнологическаяОперацияКоличество,
		|ТехнологическаяОперацияЦена,
		|ТехнологическаяОперацияКоэффициентСложности,
		|ТехнологическаяОперацияСумма");		
		ЗаполнитьЗначенияСвойств(Структура, ТекущиеДанные);
		Структура.ДатаЦен = Объект.Дата;
		Структура.ТехнологическаяОперацияКоэффициентСложности = Объект.КоэффициентСложности;
		
		ТехнологическиеОперацииТехнологическаяОперацияПриИзмененииНаСервере(Структура);
		ЗаполнитьЗначенияСвойств(ТекущиеДанные, Структура);
	КонецЕсли;		
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДоступныеТехнологическиеОперацииНаСервере(Спецификация, ВидСтадииОбработки)
	Возврат Справочники.mega_Спецификации.ПолучитьДоступныеТехнологическиеОперации(Спецификация, ВидСтадииОбработки);
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДоступныеВидыСтадийОбработкиНаСервере(Спецификация)
	Возврат Справочники.mega_Спецификации.ПолучитьДоступныеВидыСтадийОбработки(Спецификация);
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьДоступныеВидыСтадийОбработкиПоПроизводственномуРесурсуНаСервере(Спецификация, ПроизводственныйРесурс)
	Возврат Справочники.mega_Спецификации.ПолучитьДоступныеВидыСтадийОбработкиПоПроизводственномуРесурсу(
		Спецификация, ПроизводственныйРесурс);
КонецФункции


&НаСервереБезКонтекста
Процедура ТехнологическиеОперацииКоличествоПриИзмененииНаСервере(Структура)
		
	Структура.Сумма = Структура.Цена * Структура.Количество;
	
	Если ЗначениеЗаполнено(Структура.ТехнологическаяОперация) Тогда
						
		Структура.ТехнологическаяОперацияКоличество = ПолучитьДлительностьТехнологическойОперацииНаСервере(
			Структура.Спецификация, Структура.ВидСтадииОбработки, Структура.ТехнологическаяОперация) * Структура.Количество;	
		
		Структура.ТехнологическаяОперацияЦена = 
			РегистрыСведений.mega_ЦеныПлановойСебестоимости.ПолучитьПоследнююЦенуПлановойСебестоимости(
				Структура.ТехнологическаяОперация, Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка(), Структура.ДатаЦен);
		
		Коэффициент = РегистрыСведений.mega_ЗначенияКоэффициентовСложностиПроизводства.ПолучитьЗначениеКоэффициента(
			Структура.ДатаЦен, Структура.ТехнологическаяОперацияКоэффициентСложности);
		
		Структура.ТехнологическаяОперацияСумма = 
			Структура.ТехнологическаяОперацияЦена * Коэффициент * Структура.ТехнологическаяОперацияКоличество;
		
		ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзмененииНаСервере(Структура);	
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзмененииНаСервере(Структура)
		
	Коэффициент = 1;
	Если ЗначениеЗаполнено(Структура.Спецификация)
		И ЗначениеЗаполнено(Структура.ВидСтадииОбработки)
		И ЗначениеЗаполнено(Структура.ТехнологическаяОперация) Тогда

		Коэффициент = РегистрыСведений.mega_ЗначенияКоэффициентовСложностиПроизводства.ПолучитьЗначениеКоэффициента(
			Структура.ДатаЦен, Структура.ТехнологическаяОперацияКоэффициентСложности); 	
	КонецЕсли;
	Структура.ТехнологическаяОперацияСумма = 
		Структура.ТехнологическаяОперацияЦена * Коэффициент * Структура.ТехнологическаяОперацияКоличество;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТехнологическиеОперацииТехнологическаяОперацияПриИзмененииНаСервере(Структура)
	
	Структура.ТехнологическаяОперацияЕдиницаИзмерения = Справочники.mega_ЕдиницыИзмерения.ПустаяСсылка();
	
	Коэффициент = 1;		
	Если ЗначениеЗаполнено(Структура.ТехнологическаяОперация) Тогда
				
		Структура.ТехнологическаяОперацияЕдиницаИзмерения = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Структура.ТехнологическаяОперация, "ЕдиницаИзмерения");
		Структура.ТехнологическаяОперацияКоличество = ПолучитьДлительностьТехнологическойОперацииНаСервере(
			Структура.Спецификация, Структура.ВидСтадииОбработки, Структура.ТехнологическаяОперация) * Структура.Количество;	
		
		Структура.ТехнологическаяОперацияЦена = 
			РегистрыСведений.mega_ЦеныПлановойСебестоимости.ПолучитьПоследнююЦенуПлановойСебестоимости(
				Структура.ТехнологическаяОперация, Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка(), Структура.ДатаЦен);
		
		Коэффициент = РегистрыСведений.mega_ЗначенияКоэффициентовСложностиПроизводства.ПолучитьЗначениеКоэффициента(
			Структура.ДатаЦен, Структура.ТехнологическаяОперацияКоэффициентСложности);
		
		Структура.ТехнологическаяОперацияСумма = 
			Структура.ТехнологическаяОперацияЦена * Коэффициент * Структура.ТехнологическаяОперацияКоличество;
		
		ТехнологическиеОперацииТехнологическаяОперацияКоличествоПриИзмененииНаСервере(Структура);	
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТехнологическиеОперацииНоменклатураПриИзмененииНаСервере(Структура)
	
	Структура.ЕдиницаИзмерения = Справочники.mega_ЕдиницыИзмерения.ПустаяСсылка();
	Структура.Спецификация = Справочники.mega_Спецификации.ПустаяСсылка();
	Структура.ВидСтадииОбработки = Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка();
	Структура.ПредыдущийВидСтадииОбработки = Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка();
	Структура.ТехнологическаяОперация = Справочники.mega_Номенклатура.ПустаяСсылка();
	Структура.ТехнологическаяОперацияЕдиницаИзмерения = Справочники.mega_ЕдиницыИзмерения.ПустаяСсылка();
	Структура.ТехнологическаяОперацияЦена = 0;
	Структура.ТехнологическаяОперацияСумма = 0;
	Структура.ТехнологическаяОперацияКоличество = 0;
	Структура.Количество = 0;
	Структура.Цена = 0;
	Структура.Сумма = 0;
	
	Коэффициент = 1;	
	Если ЗначениеЗаполнено(Структура.Номенклатура) Тогда
		
		Структура.ЕдиницаИзмерения = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Структура.Номенклатура, "ЕдиницаИзмерения");		
		Структура.Спецификация = Справочники.mega_Спецификации.ПолучитьОсновнуюСпецификациюНоменклатуры(Структура.Номенклатура);
		
		Структура.Цена = РегистрыСведений.mega_ЦеныПлановойСебестоимости.ПолучитьПоследнююЦенуПлановойСебестоимости(
			Структура.Номенклатура, Структура.ПредыдущийВидСтадииОбработки, Структура.ДатаЦен);
			
		Коэффициент = РегистрыСведений.mega_ЗначенияКоэффициентовСложностиПроизводства.ПолучитьЗначениеКоэффициента(
			Структура.ДатаЦен, Структура.ТехнологическаяОперацияКоэффициентСложности);
		Структура.Сумма = Структура.Цена * Коэффициент * Структура.Количество; 
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ТехнологическиеОперацииПредыдущийВидСтадииОбработкиПриИзмененииНаСервере(Структура)
	
	Структура.Сумма = 0;
		
	Если ЗначениеЗаполнено(Структура.Номенклатура) Тогда
		
		Структура.Цена = РегистрыСведений.mega_ЦеныПлановойСебестоимости.ПолучитьПоследнююЦенуПлановойСебестоимости(
			Структура.Номенклатура, Структура.ПредыдущийВидСтадииОбработки, Структура.ДатаЦен);
		Структура.Сумма = Структура.Цена * Структура.Количество; 
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьДлительностьТехнологическойОперацииНаСервере(Спецификация, ВидСтадииОбработки, ТехнологическаяОперация)
    
	Возврат Справочники.mega_Спецификации.ПолучитьДлительностьТехнологическойОперации(
   		Спецификация, ВидСтадииОбработки, ТехнологическаяОперация);   
КонецФункции

&НаКлиенте
Процедура ПослеЗакрытияВопросаООчисткеТаблицыМатериалов(Результат, Параметры) Экспорт
    
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
	
	Объект.Материалы.Очистить();
		
	ЗаполнитьМатериалыПоМатериаламОперацийНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗакрытияВопросаООчисткеТаблицыМатериаловОпераций(Результат, Параметры) Экспорт
    
    Если Результат = КодВозвратаДиалога.Нет Тогда
        Возврат;
    КонецЕсли;
	
	Объект.МатериалыОпераций.Очистить();
		
	ЗаполнитьМатериалыПоСпецификацииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьМатериалыПоСпецификацииНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
    ДокументОбъект.ЗаполнитьМатериалыОпераций();
   	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ЗаполнитьОстаткиНаСервере();
	ЭтотОбъект.Модифицированность = Истина;
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьМатериалыПоМатериаламОперацийНаСервере()
	
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
    ДокументОбъект.ЗаполнитьМатериалыПоМатериаламОпераций();
   	ЗначениеВРеквизитФормы(ДокументОбъект, "Объект");
	
	ЗаполнитьОстаткиНаСервере();
	ЭтотОбъект.Модифицированность = Истина;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьПредыдущийВидСтадииОбработкиНаСервере(Структура)
	
	
	СтадияОбработкиПоВидуСтадииОбработки = 
		Справочники.mega_Спецификации.ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(Структура.Спецификация,
			Структура.ВидСтадииОбработки);
			
	ПредыдущаяСтадияОбработки = Справочники.mega_Спецификации.ПолучитьПредыдущуюСтадиюОбработки(Структура.Спецификация,
			СтадияОбработкиПоВидуСтадииОбработки);	
			
	Структура.ПредыдущийВидСтадииОбработки = ПредыдущаяСтадияОбработки.ВидСтадииОбработки;		
КонецПроцедуры

&НаСервере
Функция МожноУдалитьСтрокуТехнологическойОперации()
	
	Если Не ЗначениеЗаполнено(ТекущаяТехнологическаяОперация) Тогда 
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Объект.МатериалыОпераций.НайтиСтроки(Новый Структура("КлючСвязи", ТекущаяТехнологическаяОперация)).Количество() = 0;
КонецФункции

&НаКлиенте
Процедура УстановитьОтборСтрокМатериалы()
	
	Элементы.МатериалыОпераций.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСвязи", ТекущаяТехнологическаяОперация);
КонецПроцедуры

// Управляет доступностью элементов формы.
&НаКлиенте
Процедура УправлениеДоступностью()
	

КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	МодульПодключаемыеКомандыКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиент");
	МодульПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
	ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
	МодульПодключаемыеКоманды = ОбщегоНазначения.ОбщийМодуль("ПодключаемыеКоманды");
	МодульПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Объект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
	МодульПодключаемыеКомандыКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("ПодключаемыеКомандыКлиентСервер");
	МодульПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

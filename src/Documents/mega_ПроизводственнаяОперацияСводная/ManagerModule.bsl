///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив из Строка
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Автор");	
	Результат.Добавить("Ответственный");	
	Результат.Добавить("Комментарий");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.Взаимодействия

// Конец СтандартныеПодсистемы.Взаимодействия

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Ответственный, Отключено КАК Ложь)
	|	ИЛИ ЗначениеРазрешено(Автор, Отключено КАК Ложь)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом


// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//  КомандыПечати - см. УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ВыработкаИсполнителей";
	КомандаПечати.Представление = НСтр("ru = 'Выработка исполнителей'");	
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Выработка";
	КомандаПечати.Представление = НСтр("ru = 'Выработка'");	
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "СотрудникиНаСмене";
	КомандаПечати.Представление = НСтр("ru = 'Сотрудники на смене'");	
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Производство";
	КомандаПечати.Представление = НСтр("ru = 'Производство'");	
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;

КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ВыработкаИсполнителей");
    Если НужноПечататьМакет Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"ВыработкаИсполнителей", 
			НСтр("ru = 'Выработка исполнителей'"),
        	ПечатьВыработкиИсполнителей(МассивОбъектов, ОбъектыПечати), , "Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_ВыработкаИсполнителей");
    КонецЕсли;
    
    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Выработка");
    Если НужноПечататьМакет Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"Выработка", 
			НСтр("ru = 'Выработка'"),
        	ПечатьВыработки(МассивОбъектов, ОбъектыПечати), , "Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_Выработка");
    КонецЕсли;
    
    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СотрудникиНаСмене");
    Если НужноПечататьМакет Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"СотрудникиНаСмене", 
			НСтр("ru = 'Сотрудники на смене'"),
        	ПечатьСотрудникиНаСмене(МассивОбъектов, ОбъектыПечати), , 
        		"Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_СотрудникиНаСмене");
    КонецЕсли;
    
    НужноПечататьМакет = УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Производство");
    Если НужноПечататьМакет Тогда
		
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм, 
			"Производство", 
			НСтр("ru = 'Производство'"),
        	ПечатьПроизводство(МассивОбъектов, ОбъектыПечати), , 
        		"Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_Производство");
	КонецЕсли;
		
КонецПроцедуры



// Конец СтандартныеПодсистемы.Печать


// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
	ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании);
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Команда = СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы.Встреча);
	Если Команда <> Неопределено Тогда
		Команда.ФункциональныеОпции = "ИспользоватьПрочиеВзаимодействия";
		Команда.Важность = "СмТакже";
	КонецЕсли;
	
	Возврат Команда;
	
КонецФункции

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьОстатки(Документ)
	
	ГотоваяПродукция = Документ.ТехнологическиеОперации.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	
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
		|	И Подразделение = &Подразделение) КАК ПроизводственныеЗапасыОстатки";
	
	Запрос.УстановитьПараметр("ГотоваяПродукция", ГотоваяПродукция);
	Запрос.УстановитьПараметр("Подразделение", Документ.Подразделение);
	Запрос.УстановитьПараметр("НачалоСмены", Документ.НачалоСмены);
	Запрос.УстановитьПараметр("ОкончаниеСмены", Документ.ОкончаниеСмены);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	ВыборкаДетальныеЗаписиНачалоСмены = РезультатыЗапроса[0].Выбрать();
	ВыборкаДетальныеЗаписиОкончаниеСмены = РезультатыЗапроса[1].Выбрать();
	
	Структура = Новый Структура;
	Структура.Вставить("ОстаткиНачалаСмены", ВыборкаДетальныеЗаписиНачалоСмены);
	Структура.Вставить("ОстаткиОкончанияСмены", ВыборкаДетальныеЗаписиОкончаниеСмены);
	
	Возврат Структура;				
КонецФункции

Функция ПечатьПроизводство(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПроизводственнаяОперацияСводная_Производство";
			
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Документы.Номер,
	|	Документы.Дата,
	|	Документы.Ссылка,
	|	Документы.Подразделение,
	|	Документы.ПроизводственныйРесурс,
	|	Документы.Мастер,
	|	Документы.ПроизводственнаяСмена,
	|	Документы.НачалоСмены,
	|	Документы.ОкончаниеСмены,
	|	Документы.ВидОперации,
	|	Документы.ТехнологическиеОперации.(
	|		Ссылка,
	|		Ссылка.ПроизводственныйРесурс КАК ПроизводственныйРесурс,
	|		НомерСтроки,
	|		ТехнологическаяОперация,
	|		ТехнологическаяОперацияКоличество,
	|		ТехнологическаяОперацияЕдиницаИзмерения,
	|		ТехнологическаяОперацияКоличество КАК ВремяВыполнения,
	|		ТехнологическаяОперацияКоэффициентСложности,
	|		ТехнологическаяОперацияЦена,
	|		ТехнологическаяОперацияСумма,
	|		Номенклатура,
	|		Номенклатура.КодДетали КАК КодДетали,
	|		Спецификация,
	|		ЕдиницаИзмерения,
	|		Количество,
	|		Ответственный,
	|		ПредыдущийВидСтадииОбработки,
	|		ВидСтадииОбработки,
	|		КлючСвязи,
	|		Цена,
	|		Сумма,
	|		Станок)
	|ИЗ
	|	Документ.mega_ПроизводственнаяОперацияСводная КАК Документы
	|ГДЕ
	|	Документы.Ссылка В (&МассивОбъектов)";
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_Производство");
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.Заголовок = СтрШаблон("Отчет производства за смену %1 от %2", Шапка.Номер, Шапка.Дата);		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ВыборкаСотрудников = РегистрыСведений.mega_ДолжностностныеПоложенияСотрудников.ПолучитьСотрудниковПодразделения(
			Шапка.Подразделение, Шапка.Дата);
		
		ТехнологическиеОперации = Шапка.ТехнологическиеОперации.Выбрать();
		
		Количество = 0;
		ОстатокНаНачалоСмены = 0;
		ОстатокНаКонецСмены = 0;
		
		//@skip-check query-in-loop
		Остатки = ПолучитьОстатки(Шапка.ссылка);
		
		Пока ТехнологическиеОперации.Следующий() Цикл 
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьМакета.Параметры.Заполнить(ТехнологическиеОперации);	
			
			СтруктураПоиска = Новый Структура;
			СтруктураПоиска.Вставить("Номенклатура", ТехнологическиеОперации.Номенклатура);
			СтруктураПоиска.Вставить("ВидСтадииОбработки", ТехнологическиеОперации.ВидСтадииОбработки);
			
			Остатки.ОстаткиНачалаСмены.Сбросить();
			Если Остатки.ОстаткиНачалаСмены.НайтиСледующий(СтруктураПоиска) Тогда
				
				ОбластьМакета.Параметры.ОстатокНаНачалоСмены = Остатки.ОстаткиНачалаСмены.Остаток;
				ОстатокНаНачалоСмены = ОстатокНаНачалоСмены + Остатки.ОстаткиНачалаСмены.Остаток;
			КонецЕсли;			
			
			Остатки.ОстаткиОкончанияСмены.Сбросить();
			Если Остатки.ОстаткиОкончанияСмены.НайтиСледующий(СтруктураПоиска) Тогда
				
				ОбластьМакета.Параметры.ОстатокНаКонецСмены = Остатки.ОстаткиОкончанияСмены.Остаток;
				ОстатокНаКонецСмены = ОстатокНаКонецСмены + Остатки.ОстаткиОкончанияСмены.Остаток;
			КонецЕсли;
			
			Количество = Количество + ТехнологическиеОперации.Количество;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итог");
		ОбластьМакета.Параметры.Заполнить(Шапка);				
		ОбластьМакета.Параметры.Количество = Количество;
		ОбластьМакета.Параметры.ОстатокНаНачалоСмены = ОстатокНаНачалоСмены;
		ОбластьМакета.Параметры.ОстатокНаКонецСмены = ОстатокНаКонецСмены;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		
		ОбластьМакета.Параметры.НачальникЦеха = ПолучитьНачальникаЦеха(Шапка.Подразделение, Шапка.Дата);						
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
				
	КонецЦикла;

	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьСотрудникиНаСмене(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПроизводственнаяОперацияСводная_СотрудникиНаСмене";
			
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Документы.Номер,
	|	Документы.Дата,
	|	Документы.Ссылка,
	|	Документы.Подразделение,
	|	Документы.ПроизводственныйРесурс,
	|	Документы.Мастер,
	|	Документы.ПроизводственнаяСмена,
	|	Документы.НачалоСмены,
	|	Документы.ОкончаниеСмены,
	|	Документы.ВидОперации,
	|	Документы.ТехнологическиеОперации.(
	|		Ссылка,
	|		Ссылка.ПроизводственныйРесурс КАК ПроизводственныйРесурс,
	|		НомерСтроки,
	|		ТехнологическаяОперация,
	|		ТехнологическаяОперацияКоличество,
	|		ТехнологическаяОперацияЕдиницаИзмерения,
	|		ТехнологическаяОперацияКоличество КАК ВремяВыполнения,
	|		ТехнологическаяОперацияКоэффициентСложности,
	|		ТехнологическаяОперацияЦена,
	|		ТехнологическаяОперацияСумма,
	|		Номенклатура,
	|		Номенклатура.КодДетали КАК КодДетали,
	|		Спецификация,
	|		ЕдиницаИзмерения,
	|		Количество,
	|		Ответственный,
	|		ПредыдущийВидСтадииОбработки,
	|		ВидСтадииОбработки,
	|		КлючСвязи,
	|		Цена,
	|		Сумма,
	|		Станок)
	|ИЗ
	|	Документ.mega_ПроизводственнаяОперацияСводная КАК Документы
	|ГДЕ
	|	Документы.Ссылка В (&МассивОбъектов)";
	
	Шапка = Запрос.Выполнить().Выбрать();
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_СотрудникиНаСмене");
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.Заголовок = СтрШаблон("Отчет производства за смену %1 от %2", Шапка.Номер, Шапка.Дата);		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ВыборкаСотрудников = РегистрыСведений.mega_ДолжностностныеПоложенияСотрудников.ПолучитьСотрудниковПодразделения(
			Шапка.Подразделение, Шапка.Дата);
		
		ТехнологическиеОперации = Шапка.ТехнологическиеОперации.Выбрать();
		
		ВремяВыполнения = 0;
		Количество = 0;
		Сумма = 0;
		
		Пока ТехнологическиеОперации.Следующий() Цикл 
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьМакета.Параметры.Заполнить(ТехнологическиеОперации);
			
			ДатаЧастями = mega_МетодыРаботыСДатами.ПолучитьДатуЧастями(ТехнологическиеОперации.ВремяВыполнения);
			ВремяВЧасахМинутах = mega_МетодыРаботыСДатами.ПолучитьВремяВЧасахМинутахСекундахСтрокой(ДатаЧастями);
				
			ОбластьМакета.Параметры.ВремяВыполнения = ВремяВЧасахМинутах;
			
			ОбластьМакета.Параметры.Должность = 
				ПолучитьДолжностьСотрудника(ВыборкаСотрудников, ТехнологическиеОперации.Ответственный);			
			
			ВремяВыполнения = ВремяВыполнения + ТехнологическиеОперации.ВремяВыполнения;
			Количество = Количество + ТехнологическиеОперации.Количество;
			Сумма = Сумма + ТехнологическиеОперации.Сумма;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		
		
		ОбластьМакета = Макет.ПолучитьОбласть("Итог");
		ОбластьМакета.Параметры.Заполнить(Шапка);
				
		ДатаЧастями = mega_МетодыРаботыСДатами.ПолучитьДатуЧастями(ВремяВыполнения);
		ВремяВЧасахМинутах = mega_МетодыРаботыСДатами.ПолучитьВремяВЧасахМинутахСекундахСтрокой(ДатаЧастями);		
		
		ОбластьМакета.Параметры.ВремяВыполнения = ВремяВЧасахМинутах;
		ОбластьМакета.Параметры.Количество = Количество;
		ОбластьМакета.Параметры.Сумма = Сумма;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		
		ОбластьМакета.Параметры.НачальникЦеха = ПолучитьНачальникаЦеха(Шапка.Подразделение, Шапка.Дата);						
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
				
	КонецЦикла;

	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьВыработкиИсполнителей(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПроизводственнаяОперацияСводная_ВыработкаИсполнителей";
			
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТехнологическиеОперации.Ответственный,
	|	ТехнологическиеОперации.ТехнологическаяОперация,
	|	ТехнологическиеОперации.ТехнологическаяОперацияКоличество КАК Количество,
	|	ТехнологическиеОперации.ТехнологическаяОперацияКоличество КАК ВремяВыполнения,
	|	ТехнологическиеОперации.ТехнологическаяОперацияЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ТехнологическиеОперации.ВидСтадииОбработки,
	|	ТехнологическиеОперации.Ссылка КАК Ссылка,
	|	ТехнологическиеОперации.Ссылка.Номер,
	|	ТехнологическиеОперации.Ссылка.Дата
	|ИЗ
	|	Документ.mega_ПроизводственнаяОперацияСводная.ТехнологическиеОперации КАК ТехнологическиеОперации
	|ГДЕ
	|	ТехнологическиеОперации.Ссылка В (&МассивОбъектов)
	|ИТОГИ
	|ПО
	|	Ссылка";
	
	Шапка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_ВыработкаИсполнителей");
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заголовок = СтрШаблон("Выработка исполнителей %1 от %2", Шапка.Номер, Шапка.Дата);		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		ТехнологическиеОперации = Шапка.Выбрать();
		Пока ТехнологическиеОперации.Следующий() Цикл 
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьМакета.Параметры.Заполнить(ТехнологическиеОперации);
			
			ДатаЧастями = mega_МетодыРаботыСДатами.ПолучитьДатуЧастями(ТехнологическиеОперации.ВремяВыполнения);
			ВремяВЧасахМинутах = mega_МетодыРаботыСДатами.ПолучитьВремяВЧасахМинутахСекундахСтрокой(ДатаЧастями);
				
			ОбластьМакета.Параметры.ВремяВыполнения = ВремяВЧасахМинутах;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
				
	КонецЦикла;

	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьВыработки(МассивОбъектов, ОбъектыПечати)
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.АвтоМасштаб			= Истина;
	ТабличныйДокумент.ОриентацияСтраницы	= ОриентацияСтраницы.Портрет;
	ТабличныйДокумент.КлючПараметровПечати	= "ПАРАМЕТРЫ_ПЕЧАТИ_ПроизводственнаяОперацияСводная_Выработка";
			
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТехнологическиеОперации.Ответственный,
	|	ТехнологическиеОперации.Номенклатура,
	|	ТехнологическиеОперации.ТехнологическаяОперация,
	|	ТехнологическиеОперации.Количество,
	|	ТехнологическиеОперации.ЕдиницаИзмерения,
	|	ТехнологическиеОперации.ВидСтадииОбработки,
	|	ТехнологическиеОперации.Ссылка КАК Ссылка,
	|	ТехнологическиеОперации.Ссылка.Номер,
	|	ТехнологическиеОперации.Ссылка.Дата
	|ИЗ
	|	Документ.mega_ПроизводственнаяОперацияСводная.ТехнологическиеОперации КАК ТехнологическиеОперации
	|ГДЕ
	|	ТехнологическиеОперации.Ссылка В (&МассивОбъектов)
	|ИТОГИ
	|ПО
	|	Ссылка";
	
	Шапка = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ПервыйДокумент = Истина;
	
	Пока Шапка.СледующийПоЗначениюПоля("Ссылка") Цикл
		
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.mega_ПроизводственнаяОперацияСводная.ПФ_MXL_Выработка");
	
		Если НЕ ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		// Запомним номер строки, с которой начали выводить текущий документ.
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		// Выводим шапку накладной

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заголовок = СтрШаблон("Выработка %1 от %2", Шапка.Номер, Шапка.Дата);		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		ТехнологическиеОперации = Шапка.Выбрать();
		Пока ТехнологическиеОперации.Следующий() Цикл 
			
			ОбластьМакета = Макет.ПолучитьОбласть("Строка");
			ОбластьМакета.Параметры.Заполнить(ТехнологическиеОперации);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;		
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");		
		ТабличныйДокумент.Вывести(ОбластьМакета);

		
		// В табличном документе зададим имя области, в которую был 
		// выведен объект. Нужно для возможности печати покомплектно.
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
			НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
				
	КонецЦикла;

	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПолучитьНачальникаЦеха(Подразделение, ДатаСреза)
	
	НачальникиЦеха = РегистрыСведений.mega_ДолжностностныеПоложенияСотрудников.ПолучитьНачальниковЦеха(Подразделение, ДатаСреза);
	Если НачальникиЦеха.Количество() > 0 Тогда
		
		Возврат НачальникиЦеха[0];
	КонецЕсли;
	
	Возврат Неопределено;
КонецФункции

Функция ПолучитьДолжностьСотрудника(ВыборкаСотрудников, Сотрудник)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("Сотрудник", Сотрудник);
	ВыборкаСотрудников.Сбросить();
		
	Если ВыборкаСотрудников.НайтиСледующий(СтруктураПоиска) Тогда
		
		Возврат ВыборкаСотрудников.Должность;
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

#КонецОбласти

#КонецЕсли

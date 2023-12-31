///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс


// Заполняет "Материалы спецификаций" и "Материалы" по данным спецификаций операций
Процедура ЗаполнитьМатериалыОпераций() Экспорт 
	
	Спецификации = ПолучитьСпецификацииДокумента();	
	МатериалыСпецификаций = ПолучитьМатериалыСпецификаций(Спецификации);	
	
	Для Каждого ТекСтрокаТехнологическиеОперации Из ТехнологическиеОперации Цикл
		
		Если ЗначениеЗаполнено(ТекСтрокаТехнологическиеОперации.Спецификация) И 
			ЗначениеЗаполнено(ТекСтрокаТехнологическиеОперации.ВидСтадииОбработки) Тогда
			
			СтадияОбработкиПоВидуСтадииОбработки = 
				Справочники.mega_Спецификации.ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(ТекСтрокаТехнологическиеОперации.Спецификация,
					ТекСтрокаТехнологическиеОперации.ВидСтадииОбработки);
			
			ПараметрыПоиска = Новый Структура;
			ПараметрыПоиска.Вставить("Спецификация", ТекСтрокаТехнологическиеОперации.Спецификация);
			ПараметрыПоиска.Вставить("КлючСвязи", СтадияОбработкиПоВидуСтадииОбработки.КлючСвязи);
			
			МатериалыСпецификаций.Сбросить();
			Пока МатериалыСпецификаций.НайтиСледующий(ПараметрыПоиска) Цикл
				
				НоваяСтрока = МатериалыОпераций.Добавить();
				НоваяСтрока.КлючСвязи = ТекСтрокаТехнологическиеОперации.КлючСвязи;
				НоваяСтрока.Номенклатура = МатериалыСпецификаций.Материал;
				НоваяСтрока.ЕдиницаИзмерения = МатериалыСпецификаций.ЕдиницаИзмерения;
				НоваяСтрока.Количество = МатериалыСпецификаций.Количество * ТекСтрокаТехнологическиеОперации.Количество;
				НоваяСтрока.КоличествоПоСпецификации = НоваяСтрока.Количество;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	ЗаполнитьМатериалыПоМатериаламОпераций();
КонецПроцедуры //ЗаполнитьМатериалы

// Сворачивает "Материалы операций" и загружает данные в "Материалы"
Процедура ЗаполнитьМатериалыПоМатериаламОпераций()Экспорт
	
	ВремМатериалыОпераций = МатериалыОпераций.Выгрузить();
	ВремМатериалыОпераций.Свернуть("Номенклатура,ЕдиницаИзмерения,Спецификация,ВидСтадииОбработки", "Количество,КоличествоПоСпецификации");
	Материалы.Загрузить(ВремМатериалыОпераций);
КонецПроцедуры //ЗаполнитьМатериалыПоМатериаламОпераций

#Область ДляВызоваИзДругихПодсистем

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
    	
	Автор = Пользователи.ТекущийПользователь();
	Ответственный = Автор;
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.mega_СменноеЗадание") Тогда
		
		ЗаполнитьНаОснованииСменногоЗадания(ДанныеЗаполнения);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// регистр mega_ПроизводственныеЗапасы Приход	
	Движения.mega_ПроизводственныеЗапасы.Записывать = Истина;
	Движения.mega_ВыработкаИсполнителей.Записывать = Истина;
	Движения.mega_ВыпускПродукции.Записывать = Истина;	
	
	Для Каждого ТекСтрока Из ТехнологическиеОперации Цикл
		
		//Работы
		Движение = Движения.mega_ВыработкаИсполнителей.Добавить();		
		Движение.Период = Дата;
		Движение.Исполнитель = ТекСтрока.Ответственный;
		Движение.ТехнологическаяОперация = ТекСтрока.ТехнологическаяОперация;
		Движение.Количество = ТекСтрока.ТехнологическаяОперацияКоличество;
		Движение.Время = ТекСтрока.ТехнологическаяОперацияКоличество;
		
		НеПроизводственная = 
			ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекСтрока.ТехнологическаяОперация, "НеПроизводственная");
		Если Не НеПроизводственная Тогда
			
			//Запасы
			Движение = Движения.mega_ПроизводственныеЗапасы.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			Движение.Период = Дата;
			Движение.Подразделение = Подразделение;
			Движение.Номенклатура = ТекСтрока.Номенклатура;
			Движение.ВидСтадииОбработки = ТекСтрока.ВидСтадииОбработки;
			Движение.Количество = ТекСтрока.Количество;
			
			Если ЗначениеЗаполнено(ТекСтрока.ПредыдущийВидСтадииОбработки) Тогда 
				
				Движение = Движения.mega_ПроизводственныеЗапасы.Добавить();
				Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
				Движение.Период = Дата;
				Движение.Подразделение = Подразделение;
				Движение.Номенклатура = ТекСтрока.Номенклатура;
				Движение.ВидСтадииОбработки = ТекСтрока.ПредыдущийВидСтадииОбработки;
				Движение.Количество = ТекСтрока.Количество;		
			КонецЕсли;
		
			//ВыпускПродукции
			Движение = Движения.mega_ВыпускПродукции.Добавить();		
			Движение.Период = Дата;
			Движение.Подразделение = Подразделение;
			Движение.Продукция = ТекСтрока.Номенклатура;
			Движение.ВидСтадииОбработкиПродукции = ТекСтрока.ВидСтадииОбработки;
			Движение.КоличествоПродукции = ТекСтрока.Количество;
			
			Движение = Движения.mega_ВыпускПродукции.Добавить();		
			Движение.Период = Дата;
			Движение.Подразделение = Подразделение;
			Движение.Продукция = ТекСтрока.Номенклатура;
			Движение.ВидСтадииОбработкиПродукции = ТекСтрока.ВидСтадииОбработки;
			
			Движение.Сырье = ТекСтрока.Номенклатура;
			Движение.ВидСтадииОбработкиСырья = ТекСтрока.ПредыдущийВидСтадииОбработки;
			Движение.КоличествоСырья = ТекСтрока.Количество;
			Движение.СуммаСырья = ТекСтрока.Сумма;
			
			Движение = Движения.mega_ВыпускПродукции.Добавить();		
			Движение.Период = Дата;
			Движение.Подразделение = Подразделение;
			Движение.Продукция = ТекСтрока.Номенклатура;
			Движение.ВидСтадииОбработкиПродукции = ТекСтрока.ВидСтадииОбработки;
			
			Движение.Сырье = ТекСтрока.ТехнологическаяОперация;
			Движение.КоличествоСырья = ТекСтрока.ТехнологическаяОперацияКоличество;
			Движение.СуммаСырья = ТекСтрока.ТехнологическаяОперацияСумма;
			
			ПараметрыПоиска = Новый Структура;
			ПараметрыПоиска.Вставить("КлючСвязи", ТекСтрока.КлючСвязи);
			Для Каждого ТекМатериалыОпераций Из МатериалыОпераций.НайтиСтроки(ПараметрыПоиска) Цикл
				
				Движение = Движения.mega_ВыпускПродукции.Добавить();		
				Движение.Период = Дата;
				Движение.Подразделение = Подразделение;
				Движение.Продукция = ТекСтрока.Номенклатура;
				Движение.ВидСтадииОбработкиПродукции = ТекСтрока.ВидСтадииОбработки;
				
				Движение.Сырье = ТекМатериалыОпераций.Номенклатура;
				Движение.КоличествоСырья = ТекМатериалыОпераций.Количество;
				Движение.СуммаСырья = ТекМатериалыОпераций.Сумма;
			КонецЦикла;	
				
		КонецЕсли;
	КонецЦикла;
		
	//Материалы
	Для Каждого ТекСтрока Из Материалы Цикл 
		
		Движение = Движения.mega_ПроизводственныеЗапасы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.Номенклатура = ТекСтрока.Номенклатура;		
		Движение.Количество = ТекСтрока.Количество;
	КонецЦикла;
		
	Для Каждого ТекСтрока Из ВозвратныеОтходы Цикл
		
		//Запасы
		Движение = Движения.mega_ПроизводственныеЗапасы.Добавить();
		Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
		Движение.Период = Дата;
		Движение.Подразделение = Подразделение;
		Движение.Номенклатура = ТекСтрока.Номенклатура;
		Движение.ВидСтадииОбработки = ТекСтрока.ВидСтадииОбработки;
		Движение.Количество = ТекСтрока.Количество;
	КонецЦикла;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
		
	Ответственный    = Пользователи.ТекущийПользователь();
	Автор            = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
    
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаОснованииСменногоЗадания(СменноеЗадание)
	
	ДатаЦен = ТекущаяДатаСеанса();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	СменноеЗадание.Подразделение,
		|	СменноеЗадание.ПроизводственныйРесурс,
		|	СменноеЗадание.Мастер,
		|	СменноеЗадание.ПроизводственнаяСмена,
		|	СменноеЗадание.НачалоСмены,
		|	СменноеЗадание.ОкончаниеСмены,
		|	СменноеЗадание.Ссылка КАК СменноеЗадание
		|ИЗ
		|	Документ.mega_СменноеЗадание КАК СменноеЗадание
		|ГДЕ
		|	СменноеЗадание.Ссылка = &СменноеЗадание
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТехнологическиеОперации.НомерСтроки КАК НомерСтроки,
		|	ТехнологическиеОперации.Номенклатура,
		|	ТехнологическиеОперации.Спецификация,
		|	ТехнологическиеОперации.ЕдиницаИзмерения,
		|	ТехнологическиеОперации.Количество,
		|	ТехнологическиеОперации.ВидСтадииОбработки,
		|	ТехнологическиеОперации.ТехнологическаяОперация,
		|	ТехнологическиеОперации.ТехнологическаяОперацияКоличество,
		|	ТехнологическиеОперации.ТехнологическаяОперацияЕдиницаИзмерения,
		|	ТехнологическиеОперации.ТехнологическаяОперацияВремяВыполнения,
		|	ТехнологическиеОперации.Ответственный,
		|	ТехнологическиеОперации.Станок
		|ИЗ
		|	Документ.mega_СменноеЗадание.ТехнологическиеОперации КАК ТехнологическиеОперации
		|ГДЕ
		|	ТехнологическиеОперации.Ссылка = &СменноеЗадание
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	Запрос.УстановитьПараметр("СменноеЗадание", СменноеЗадание);
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса[0].Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ВыборкаДетальныеЗаписи);
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатыЗапроса[1].Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НоваяСтрока = ТехнологическиеОперации.Добавить();
		НоваяСтрока.КлючСвязи = Новый УникальныйИдентификатор();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
		
		СтадияОбработки = 
			Справочники.mega_Спецификации.ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(
				ВыборкаДетальныеЗаписи.Спецификация, ВыборкаДетальныеЗаписи.ВидСтадииОбработки);
		ПредыдущаяСтадияОбработки = Справочники.mega_Спецификации.ПолучитьПредыдущуюСтадиюОбработки(
			ВыборкаДетальныеЗаписи.Спецификация, СтадияОбработки);
		НоваяСтрока.ПредыдущийВидСтадииОбработки = ПредыдущаяСтадияОбработки.ВидСтадииОбработки;
		
		НоваяСтрока.Цена = РегистрыСведений.mega_ЦеныПлановойСебестоимости.ПолучитьПоследнююЦенуПлановойСебестоимости(
			НоваяСтрока.Номенклатура, НоваяСтрока.ПредыдущийВидСтадииОбработки, ДатаЦен);
			
		Коэффициент = 1;
		НоваяСтрока.Сумма = НоваяСтрока.Цена * Коэффициент * НоваяСтрока.Количество;
		
		НоваяСтрока.ТехнологическаяОперацияЦена = 
			РегистрыСведений.mega_ЦеныПлановойСебестоимости.ПолучитьПоследнююЦенуПлановойСебестоимости(
				НоваяСтрока.ТехнологическаяОперация, Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка(), ДатаЦен);
			
		
		Если ЗначениеЗаполнено(НоваяСтрока.Спецификация)
			И ЗначениеЗаполнено(НоваяСтрока.ВидСтадииОбработки)
			И ЗначениеЗаполнено(НоваяСтрока.ТехнологическаяОперация) Тогда
	
			Коэффициент = РегистрыСведений.mega_ЗначенияКоэффициентовСложностиПроизводства.ПолучитьЗначениеКоэффициента(
				ДатаЦен, НоваяСтрока.ТехнологическаяОперацияКоэффициентСложности); 	
		КонецЕсли;
		НоваяСтрока.ТехнологическаяОперацияСумма = 
			НоваяСтрока.ТехнологическаяОперацияЦена * Коэффициент * НоваяСтрока.ТехнологическаяОперацияКоличество;
	КонецЦикла;
	
	ЗаполнитьМатериалыОпераций();
КонецПроцедуры


// Возвращает массив уникальных спецификаций операций документа
// 
// Возвращаемое значение:
//  Массив Из СправочникСсылка.mega_Спецификации
Функция ПолучитьСпецификацииДокумента()
	
	ВременныеТехнологическиеОперации = ТехнологическиеОперации.Выгрузить();
	ВременныеТехнологическиеОперации.Свернуть("Спецификация");
	Возврат ВременныеТехнологическиеОперации.ВыгрузитьКолонку("Спецификация");
КонецФункции //ПолучитьСпецификацииДокумента()

// Получить материалы спецификаций.
// 
// Параметры:
//  Спецификации - Массив Из СправочникСсылка.mega_Спецификации
// 
// Возвращаемое значение:
//  ВыборкаИзРезультатаЗапроса - Получить материалы спецификаций
Функция ПолучитьМатериалыСпецификаций(Спецификации)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	МатериалыСпецификаций.Ссылка КАК Спецификация,
		|	МатериалыСпецификаций.Номенклатура КАК Материал,
		|	МатериалыСпецификаций.Количество / МатериалыСпецификаций.Ссылка.Количество КАК Количество,
		|	МатериалыСпецификаций.ЕдиницаИзмерения,
		|	МатериалыСпецификаций.СтадияОбработки,
		|	МатериалыСпецификаций.КлючСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.Материалы КАК МатериалыСпецификаций
		|ГДЕ
		|	МатериалыСпецификаций.Ссылка В (&Спецификации)";
	
	Запрос.УстановитьПараметр("Спецификации", Спецификации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Возврат ВыборкаДетальныеЗаписи;
КонецФункции //ПолучитьМатериалыСпецификаций

Процедура ЗаполнитьТехнологическиеОперации()
	
	
КонецПроцедуры

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
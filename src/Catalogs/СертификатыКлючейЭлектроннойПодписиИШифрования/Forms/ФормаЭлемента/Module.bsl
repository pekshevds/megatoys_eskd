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
	
	ЭлектроннаяПодписьСлужебный.НастроитьПояснениеВводаПароля(ЭтотОбъект,
		Элементы.ВводитьПарольВПрограммеЭлектроннойПодписи.Имя);
	
	СертификатОблачнойПодписи = ИнформацияОблачнойПодписи(Объект.Программа);
	ЗаполнитьСписокПрограммСервер();
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодписьСервисаDSS")
		И ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		Элементы.Программа.Заголовок = НСтр("ru = 'Программа или сервис'");
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПриСозданииНаСервере(
			Объект, ОткрытьЗаявление);
		ИмяФормыЗаявления = "Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.Форма.Форма";
		ВозможноОткрытьЗаявление = Истина;
		Если Не ОткрытьЗаявление Тогда
			ВыпущенныеСертификаты = ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ВыпущенныеСертификаты(Объект.Ссылка);
		КонецЕсли;
		Если Не ПравоДоступа("Добавление", Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
			"ФормаСкопировать", "Видимость", Ложь);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы,
				"ФормаСкопировать", "Видимость", Ложь);
	КонецЕсли;
	
	ВстроенныйКриптопровайдер = ЭлектроннаяПодписьСлужебный.ВстроенныйКриптопровайдер();
	ОбновитьВидимостьЭлементаВводитьПарольВПрограммеЭлектроннойПодписи(ЭтотОбъект);
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	ПриСозданииНаСервереПриЧтенииНаСервере();
	
	Если Элементы.АвтоПоляИзДанныхСертификата.Видимость Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "НестандартныйСертификат");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Отказ = Истина;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ОбработчикОжиданияДобавитьСертификат", 0.1, Истина);
		Возврат;
		
	ИначеЕсли ОткрытьЗаявление Тогда
		Отказ = Истина;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПодключитьОбработчикОжидания("ОбработчикОжиданияОткрытьЗаявление", 0.1, Истина);
		Возврат;
	КонецЕсли;
	
	ОформитьСписокПользователей();
	
	ПодключитьОбработчикОжидания("ОбработчикОжиданияПоказатьСостояниеСертификата", 0.1, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если АдресСертификата <> Неопределено Тогда
		ПриСозданииНаСервереПриЧтенииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("ЭтоНовый", Не ЗначениеЗаполнено(Объект.Ссылка));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ДополнительныеПараметры = ЭлектроннаяПодписьСлужебныйКлиент.ПараметрыОповещенияПриЗаписиСертификата();
	Если ПараметрыЗаписи.ЭтоНовый Тогда
		ДополнительныеПараметры.ЭтоНовый = Истина;
	КонецЕсли;
	
	Оповестить("Запись_СертификатыКлючейЭлектроннойПодписиИШифрования", ДополнительныеПараметры, Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ПрограммыЭлектроннойПодписиИШифрования" Или ИмяСобытия = "Запись_УчетнойЗаписиDSS" Тогда
		ЗаполнитьСписокПрограммСервер();
		Возврат;
	КонецЕсли;

	Если ИмяСобытия = "Запись_СертификатыКлючейЭлектроннойПодписиИШифрования" И Источник = Объект.Ссылка Тогда
		Если Параметр.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		Если Параметр.Установлен Тогда
			ПодключитьОбработчикОжидания("ОбработчикОжиданияПоказатьСостояниеСертификата", 0.1, Истина);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_НаборКонстант" И Источник = "РазрешенныеНеаккредитованныеУЦ" Тогда
		
		ОбновитьВидимостьПредупреждения();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// Проверка уникальности наименования.
	Если Не Элементы.Наименование.ТолькоПросмотр Тогда
		ЭлектроннаяПодписьСлужебный.ПроверитьУникальностьПредставления(
			Объект.Наименование, Объект.Ссылка, "Объект.Наименование", Отказ);
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыРеквизитов) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого КлючИЗначение Из ПараметрыРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Свойства     = КлючИЗначение.Значение;
		
		Если Не Свойства.ПроверкаЗаполнения
		 Или ЗначениеЗаполнено(Объект[ИмяРеквизита]) Тогда
			
			Продолжить;
		КонецЕсли;
		
		Элемент = Элементы[ИмяРеквизита]; // ПолеФормы
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле %1 не заполнено.'"),
			Элемент.Заголовок);
		
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,, ИмяРеквизита,, Отказ);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПрограммаПриИзменении(Элемент)
	
	ОбновитьВидимостьЭлементаВводитьПарольВПрограммеЭлектроннойПодписи(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьСписокПользователей(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПользователиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьСписокПользователей(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура НапомнитьОПеревыпускеПриИзменении(Элемент)
	
	ЭлектроннаяПодписьСлужебныйКлиент.ИзменитьОтметкуОНапоминании(Объект.Ссылка, НапомнитьОПеревыпуске, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПеревыпущенОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
		
	СтандартнаяОбработка = Ложь;
	Если ВыпущенныеСертификаты.Количество() = 1 Тогда
		ОткрытьСертификатПослеВыбораИзСписка(ВыпущенныеСертификаты[0], Неопределено);
	Иначе	
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьСертификатПослеВыбораИзСписка", ЭтотОбъект, Элемент);
		ПоказатьВыборИзСписка(ОписаниеОповещения, ВыпущенныеСертификаты);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредупреждениеОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	ДополнительныеПараметры = Новый Структура("Сертификат", Объект.Ссылка);
	ЭлектроннаяПодписьСлужебныйКлиент.ОбработатьНавигационнуюСсылкуКлассификатора(
		Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка, ДополнительныеПараметры);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьАвтозаполняемыеРеквизиты(Команда)
	
	Показать = Не Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка;
	
	Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка = Показать;
	Элементы.АвтоПоляИзДанныхСертификата.Видимость = Показать;
	
	Если ЕстьОрганизации Тогда
		Элементы.Организация.Видимость = Показать;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДанныеСертификата(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ОткрытиеИзФормыЭлементаСертификата");
	ПараметрыФормы.Вставить("АдресСертификата", АдресСертификата);
	
	ОткрытьФорму("ОбщаяФорма.Сертификат", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьЗаявлениеПоКоторомуБылПолученСертификат(Команда)
	
	Если ВозможноОткрытьЗаявление Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СертификатСсылка", Объект.Ссылка);
		ОткрытьФорму(ИмяФормыЗаявления, ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьСертификат(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Сертификат еще не записан.'"));
		Возврат;
	КонецЕсли;
	
	Если Модифицированность И Не Записать() Тогда
		Возврат;
	КонецЕсли;
	
	ЭлектроннаяПодписьКлиент.ПроверитьСертификатСправочника(Объект.Ссылка,
		Новый Структура("БезПодтверждения", Истина));
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьДанныеСертификатаВФайл(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СохранитьСертификат(Неопределено, АдресСертификата);
	
КонецПроцедуры

&НаКлиенте
Процедура СертификатОтозван(Команда)
	
	Если Не Объект.Отозван Тогда
		ОписаниеСледующее = Новый ОписаниеОповещения("ПослеОтветаНаВопросСертификатОтозван", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеСледующее, НСтр("ru = 'Сертификат будет помечен как отозванный, его нельзя будет использовать для подписи в программе. 
		|Рекомендуется устанавливать этот признак, когда подано, но еще не исполнено заявление на отзыв сертификата.
		|Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	Иначе
		ОписаниеСледующее = Новый ОписаниеОповещения("ПослеОтветаНаВопросСертификатОтозван", ЭтотОбъект);
		ПоказатьВопрос(ОписаниеСледующее, НСтр("ru = 'Если сертификат отозван в удостоверяющем центре, сделать подпись таким сертификатом будет невозможно, даже если снять отметку в программе.
		|Продолжить?'"), РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Скопировать(Команда)
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("СоздатьЗаявление", Истина);
	ПараметрыСоздания.Вставить("СертификатОснование", Объект.Ссылка);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура СброситьПароль(Команда)
	
	ЭлектроннаяПодписьСлужебныйКлиент.СброситьПарольВПамяти(Объект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СменитьПинКод(Команда)
	
	МодульСервисКриптографииDSSКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиентСервер");
	МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
	
	ПредставлениеОтпечатка = МодульСервисКриптографииDSSКлиентСервер.ТрансформироватьОтпечаток(Объект.Отпечаток);
	ОписаниеСледующее = Новый ОписаниеОповещения("ПослеСменыПинКода", ЭтотОбъект);
	МодульСервисКриптографииDSSКлиент.СменитьПинКодСертификата(
			ОписаниеСледующее,
			Объект.Программа,
			Новый Структура("Отпечаток", ПредставлениеОтпечатка));
	
КонецПроцедуры

&НаКлиенте
Процедура РедактироватьИмяИОтчество(Команда)
	
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма.РедактироватьИмяИОтчество",
		Новый Структура("Имя, Отчество", Объект.Имя, Объект.Отчество), ЭтотОбъект,,,,
		Новый ОписаниеОповещения("РедактироватьИмяИОтчествоПродолжение", ЭтотОбъект),
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриСозданииНаСервереПриЧтенииНаСервере()
	
	Если Метаданные.Обработки.Найти("ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата") <> Неопределено Тогда
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата =
			ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
				"Обработка.ЗаявлениеНаВыпускНовогоКвалифицированногоСертификата");
		ОбработкаЗаявлениеНаВыпускНовогоКвалифицированногоСертификата.ПриСозданииНаСервереПриЧтенииНаСервере(
			Объект, Элементы);
	КонецЕсли;
	
	ДвоичныеДанныеСертификата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
		Объект.Ссылка, "ДанныеСертификата").Получить();
	
	Если ТипЗнч(ДвоичныеДанныеСертификата) = Тип("ДвоичныеДанные") Тогда
		
		Сертификат = Новый СертификатКриптографии(ДвоичныеДанныеСертификата);
		Если ЗначениеЗаполнено(АдресСертификата) Тогда
			ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, АдресСертификата);
		Иначе
			АдресСертификата = ПоместитьВоВременноеХранилище(ДвоичныеДанныеСертификата, УникальныйИдентификатор);
		КонецЕсли;
			
		ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(ОписаниеДанныхСертификата,
			ЭлектроннаяПодпись.СвойстваСертификата(Сертификат));
		ОбновитьВидимостьПредупреждения(Сертификат);
		
	Иначе
		АдресСертификата = "";
		Элементы.ПоказатьДанныеСертификата.Доступность  = Ложь;
		Элементы.ПредупреждениеГруппа.Видимость = Ложь;
		Элементы.ФормаПроверитьСертификат.Доступность = ЗначениеЗаполнено(ДвоичныеДанныеСертификата);
		Элементы.ФормаСохранитьДанныеСертификатаВФайл.Доступность = Ложь;
		Элементы.АвтоПоляИзДанныхСертификата.Видимость = Истина;
		Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка = Истина;
		Если ЗначениеЗаполнено(ДвоичныеДанныеСертификата) Тогда
			// Поддержка отображения основных свойств нестандартных сертификатов (система iBank2).
			ЭлектроннаяПодписьСлужебныйКлиентСервер.ЗаполнитьОписаниеДанныхСертификата(ОписаниеДанныхСертификата, Объект);
		КонецЕсли;
	КонецЕсли;
	
	Элементы.ФормаСертификатОтозван.Пометка = Объект.Отозван;

	Если Не Пользователи.ЭтоПолноправныйПользователь() Тогда
		ЭтоАвтор = Объект.Добавил = Пользователи.ТекущийПользователь();
		СертификатДоступен = СертификатДоступенПользователю();
		
		Если НЕ ЭтоАвтор И НЕ СертификатДоступен Тогда
			// Обычный пользователь может изменять только свои сертификаты.
			ТолькоПросмотр = Истина;
			Элементы.РедактироватьИмяИОтчество.Видимость = Ложь;
			
		Иначе
			// Обычный пользователь не может изменить права доступа.
			Элементы.ФизическоеЛицо.ТолькоПросмотр = Не ЗначениеЗаполнено(Объект.ФизическоеЛицо);
			Если НЕ ЭтоАвтор Тогда
				// Обычный пользователь не может изменять реквизит Пользователь,
				// если не он добавил сертификат.
				Элементы.Пользователи.ТолькоПросмотр = Истина;
				Элементы.Пользователи.КнопкаОткрытия = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	ЕстьОрганизации = Не Метаданные.ОпределяемыеТипы.Организация.Тип.СодержитТип(Тип("Строка"));
	Элементы.Организация.Видимость = ЕстьОрганизации;
	
	Если Не ЗначениеЗаполнено(АдресСертификата) Тогда
		Возврат; // Сертификат = Неопределено.
	КонецЕсли;
	
	СвойстваСубъекта = ЭлектроннаяПодпись.СвойстваСубъектаСертификата(Сертификат);
	Если СвойстваСубъекта.Фамилия <> Неопределено Тогда
		Элементы.Фамилия.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Имя <> Неопределено Тогда
		Элементы.Имя.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Свойство("Отчество") И СвойстваСубъекта.Отчество <> Неопределено Тогда
		Элементы.Отчество.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Организация <> Неопределено Тогда
		Элементы.Фирма.ТолькоПросмотр = Истина;
	КонецЕсли;
	Если СвойстваСубъекта.Свойство("Должность") И СвойстваСубъекта.Должность <> Неопределено Тогда
		Элементы.Должность.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПараметрыРеквизитов = Неопределено;
	ЭлектроннаяПодписьСлужебный.ПередНачаломРедактированияСертификатаКлюча(
		Объект.Ссылка, Сертификат, ПараметрыРеквизитов);
	
	Для каждого КлючИЗначение Из ПараметрыРеквизитов Цикл
		ИмяРеквизита = КлючИЗначение.Ключ;
		Свойства     = КлючИЗначение.Значение;
		
		Если Не Свойства.Видимость Тогда
			Элементы[ИмяРеквизита].Видимость = Ложь;
			
		ИначеЕсли Свойства.ТолькоПросмотр Тогда
			Элементы[ИмяРеквизита].ТолькоПросмотр = Истина
		КонецЕсли;
		Если Свойства.ПроверкаЗаполнения Тогда
			Элементы[ИмяРеквизита].АвтоОтметкаНезаполненного = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Элементы.АвтоПоляИзДанныхСертификата.Видимость =
		    Не Элементы.Фамилия.ТолькоПросмотр   И Не ЗначениеЗаполнено(Объект.Фамилия)
		Или Не Элементы.Имя.ТолькоПросмотр       И Не ЗначениеЗаполнено(Объект.Имя)
		Или Не Элементы.Отчество.ТолькоПросмотр  И Не ЗначениеЗаполнено(Объект.Отчество);
	
	Элементы.ФормаПоказатьАвтозаполняемыеРеквизиты.Пометка =
		Элементы.АвтоПоляИзДанныхСертификата.Видимость;
	
	Если Не ОткрытьЗаявление Тогда
		ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
		Элементы.СостояниеСертификатаГруппа.Видимость = Ложь;
		СертификатыВЛичномХранилище = Новый СписокЗначений;
		ЭлектроннаяПодписьСлужебный.ДополнитьСписокСертификатовВЛичномХранилищеНаСервере(СертификатыВЛичномХранилище);
		Если СертификатыВЛичномХранилище.НайтиПоЗначению(Объект.Отпечаток) <> Неопределено Тогда
			ВключитьВидимостьСостоянияСертификата(ЭтотОбъект, ТекущаяУниверсальнаяДата());
		КонецЕсли; 
		Если ЭлектроннаяПодпись.УправлениеОповещениямиОСертификатах() Тогда
			Элементы.НапомнитьОПеревыпуске.Видимость = Истина;
			НапомнитьОПеревыпуске = Не РегистрыСведений.ОповещенияПользователейСертификатов.ПользовательОповещен(Объект.Ссылка);
		Иначе
			Элементы.НапомнитьОПеревыпуске.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияДобавитьСертификат()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	
	ПараметрыСоздания = Новый Структура;
	ПараметрыСоздания.Вставить("ВЛичныйСписок", Истина);
	ПараметрыСоздания.Вставить("Организация", Объект.Организация);
	ПараметрыСоздания.Вставить("СкрытьЗаявление", Не ВозможноОткрытьЗаявление);
	
	ЭлектроннаяПодписьСлужебныйКлиент.ДобавитьСертификат(ПараметрыСоздания);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияОткрытьЗаявление()
	
	СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Ложь);
	
	Если ВозможноОткрытьЗаявление Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СертификатСсылка", Объект.Ссылка);
		Оповещение = Новый ОписаниеОповещения("ОповещениеОЗакрытииЗаявления", ЭтотОбъект);
		ОткрытьФорму(ИмяФормыЗаявления, ПараметрыФормы,,,,, Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповещениеОЗакрытииЗаявления(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат.Добавлен И Не ЭтотОбъект.Открыта() Тогда
		ОткрытьЗаявление = Ложь;
		СтандартныеПодсистемыКлиент.УстановитьХранениеФормы(ЭтотОбъект, Истина);
		ПриСозданииНаСервереПриЧтенииНаСервере();
		ЭтотОбъект.Открыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикОжиданияПоказатьСостояниеСертификата()
	
	Если Элементы.СостояниеСертификатаГруппа.Видимость = Истина Тогда
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения(
		"ВидимостьСостоянияСертификатаПослеПолученияСертификатовВЛичномХранилище", ЭтотОбъект);
	ЭлектроннаяПодписьСлужебныйКлиент.ПолучитьСвойстваСертификатовНаКлиенте(
		Оповещение, Истина, Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСертификатПослеВыбораИзСписка(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.ФормаОбъекта", 
			Новый Структура("Ключ", Результат.Значение));
	КонецЕсли;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьВидимостьЭлементаВводитьПарольВПрограммеЭлектроннойПодписи(Форма)
	
	Форма.Элементы.ВводитьПарольВПрограммеЭлектроннойПодписи.Видимость =
		Форма.Объект.Программа <> Форма.ВстроенныйКриптопровайдер
		И НЕ Форма.СертификатОблачнойПодписи.ОблачнаяПодпись;
	
	Форма.Элементы.ФормаСменитьПинКод.Видимость = Форма.СертификатОблачнойПодписи.ОблачнаяПодпись;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьВидимостьПредупреждения(Знач СертификатКриптографии = Неопределено)
	
	Если Объект.Отозван Тогда
		
		Элементы.ПредупреждениеГруппа.Видимость = Истина;
		Элементы.Предупреждение.Заголовок = НСтр("ru='Сертификат помечен в программе как отозванный'");
	
	ИначеЕсли Объект.ДействителенДо > ТекущаяДатаСеанса() Тогда
	
		Если ЗначениеЗаполнено(АдресСертификата) Тогда
			
			Если СертификатКриптографии = Неопределено Тогда
				СертификатКриптографии = Новый СертификатКриптографии(ПолучитьИзВременногоХранилища(АдресСертификата));
			КонецЕсли;
			
			РезультатПроверкиУдостоверяющегоЦентраСертификата = ЭлектроннаяПодписьСлужебный.РезультатПроверкиУдостоверяющегоЦентраСертификата(
					СертификатКриптографии);
			
			ДанныеПредупреждения = РезультатПроверкиУдостоверяющегоЦентраСертификата.Предупреждение;
			
			Если РезультатПроверкиУдостоверяющегоЦентраСертификата.Действует
				И Не ЗначениеЗаполнено(ДанныеПредупреждения.ТекстОшибки) Тогда
					
				Элементы.ПредупреждениеГруппа.Видимость = ЗначениеЗаполнено(ДанныеПредупреждения.ДополнительныеСведения);
				Элементы.Предупреждение.Заголовок = ДанныеПредупреждения.ДополнительныеСведения;
				
			Иначе
				Элементы.ПредупреждениеГруппа.Видимость = Истина;
				МассивСтрок = Новый Массив;
				МассивСтрок.Добавить(ДанныеПредупреждения.ТекстОшибки);
				Если ЗначениеЗаполнено(ДанныеПредупреждения.Причина) Тогда
					МассивСтрок.Добавить(Символы.ПС);
					МассивСтрок.Добавить(ДанныеПредупреждения.Причина);
				КонецЕсли;
				Если ЗначениеЗаполнено(ДанныеПредупреждения.Решение) Тогда
					МассивСтрок.Добавить(Символы.ПС);
					МассивСтрок.Добавить(ДанныеПредупреждения.Решение);
				КонецЕсли;
				Элементы.Предупреждение.Заголовок = Новый ФорматированнаяСтрока(МассивСтрок);
			КонецЕсли;
			
		Иначе
			Элементы.ПредупреждениеГруппа.Видимость = Ложь;
		КонецЕсли;
	
	Иначе
		Элементы.ПредупреждениеГруппа.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОформитьСписокПользователей()
	
	КоличествоПользователей = Объект.Пользователи.Количество();
	Если КоличествоПользователей = 1 Тогда
		ПредставлениеПользователей = СокрЛП(Объект.Пользователи[0].Пользователь);
	ИначеЕсли КоличествоПользователей > 1 Тогда
		ПредставлениеПользователей = ЭлектроннаяПодписьСлужебныйКлиентСервер.ПользователиСертификатаСтрокой(
			Объект.Пользователи[0].Пользователь, Объект.Пользователи[1].Пользователь, КоличествоПользователей);
	ИначеЕсли ЗначениеЗаполнено(Объект.Пользователь) Тогда
		ПредставлениеПользователей = СокрЛП(Объект.Пользователь);
	Иначе
		ПредставлениеПользователей = НСтр("ru = 'Не указаны'");
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура СписокПользователейЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено И ТипЗнч(РезультатВыбора) = Тип("Структура") Тогда
		Объект.Пользователи.Очистить();
		Объект.Пользователь = РезультатВыбора.Пользователь;
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицуИзМассива(Объект.Пользователи, РезультатВыбора.Пользователи, "Пользователь");
		ОформитьСписокПользователей();
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВидимостьСостоянияСертификатаПослеПолученияСертификатовВЛичномХранилище(Результат, ДополнительныеПараметры) Экспорт
	
	Для Каждого КлючИЗначение Из Результат.СвойстваСертификатовНаКлиенте Цикл
		Если КлючИЗначение.Ключ = Объект.Отпечаток Тогда
			ВключитьВидимостьСостоянияСертификата(ЭтотОбъект, ОбщегоНазначенияКлиент.ДатаУниверсальная());
			Возврат;
		КонецЕсли;	
	КонецЦикла;
		
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ВключитьВидимостьСостоянияСертификата(Форма, ТекущаяДата)
	
	Форма.Элементы.СостояниеСертификатаГруппа.Видимость = Истина;
	
	Если Форма.Объект.ДействителенДо < ТекущаяДата Тогда
		Форма.Элементы.КартинкаСертификата.Картинка = БиблиотекаКартинок.СертификатПросрочен;
		Форма.Элементы.СостояниеСертификата.Заголовок = НСтр("ru = 'Сертификат просрочен'");
	ИначеЕсли	Форма.Объект.ДействителенДо <= ТекущаяДата + 30*24*60*60 Тогда
		Форма.Элементы.КартинкаСертификата.Картинка = БиблиотекаКартинок.СрокДействияСертификатаЗаканчивается;
		Форма.Элементы.СостояниеСертификата.Заголовок = НСтр("ru = 'Срок действия сертификата скоро закончится'");
	Иначе
		Форма.Элементы.КартинкаСертификата.Картинка = БиблиотекаКартинок.СертификатВЛичномХранилище;
		Форма.Элементы.СостояниеСертификата.Заголовок = НСтр("ru = 'Сертификат в личном хранилище'");
	КонецЕсли;
		
	Если Форма.ВыпущенныеСертификаты.Количество() > 0 Тогда
		Форма.Элементы.ДекорацияПеревыпущен.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСменыПинКода(РезультатВызова, ДополнительныеПараметры) Экспорт
	
	МодульСервисКриптографииDSSКлиентСервер = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиентСервер");
	МодульСервисКриптографииDSSКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("СервисКриптографииDSSКлиент");
	
	Если РезультатВызова.Выполнено Тогда
		ПоказатьПредупреждение(Неопределено, 
				НСтр("ru = 'Смена пин-кода выполнена успешно.'", ОбщегоНазначенияКлиент.КодОсновногоЯзыка()), 30);
				
	ИначеЕсли НЕ МодульСервисКриптографииDSSКлиентСервер.ЭтоОшибкаОтказа(РезультатВызова.Ошибка) Тогда
		МодульСервисКриптографииDSSКлиент.ВывестиОшибку(Неопределено, РезультатВызова.Ошибка);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеОтветаНаВопросСертификатОтозван(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Отозван = Не Объект.Отозван;
	Элементы.ФормаСертификатОтозван.Пометка = Объект.Отозван;
	ОбновитьВидимостьПредупреждения();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьСписокПользователей(РежимПросмотра)
	
	МассивПользователей = Новый Массив;
	Для Каждого СтрокаТаблицы Из Объект.Пользователи Цикл
		МассивПользователей.Добавить(СтрокаТаблицы.Пользователь);
	КонецЦикла;	
	
	ОповещениеЗавершения = Новый ОписаниеОповещения("СписокПользователейЗавершение", ЭтотОбъект);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Пользователь", Объект.Пользователь);
	ПараметрыФормы.Вставить("Пользователи", МассивПользователей);
	ПараметрыФормы.Вставить("РежимПросмотра", РежимПросмотра ИЛИ ТолькоПросмотр);
	
	ОткрытьФорму("Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Форма.СписокПользователей", 
			ПараметрыФормы, ЭтотОбъект, , , , ОповещениеЗавершения);
			
КонецПроцедуры

&НаСервере
Функция СертификатДоступенПользователю()
	
	Если Не ПравоДоступа("Изменение", Метаданные.Справочники.СертификатыКлючейЭлектроннойПодписиИШифрования) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекПользователь = Пользователи.ТекущийПользователь();
	
	НашлиСтроки = Объект.Пользователи.НайтиСтроки(Новый Структура("Пользователь", ТекПользователь));
	Результат = НашлиСтроки.Количество() > 0 ИЛИ Объект.Пользователь = ТекПользователь;
		
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокПрограммСервер()
	
	СписокВыбора = Элементы.Программа.СписокВыбора;
	СписокВыбора.Очистить();
	ВесьСписок = ЗаполнитьСписокПрограмм(Объект.Программа);
	
	Для каждого СтрокаСписка Из ВесьСписок Цикл
		НоваяСтрока = СписокВыбора.Добавить(СтрокаСписка.Значение);
		НоваяСтрока.Картинка = СтрокаСписка.Картинка;
		НоваяСтрока.Представление = СтрокаСписка.Представление;
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИнформацияОблачнойПодписи(ТекущаяПрограмма)
	
	Результат = Новый Структура();
	Результат.Вставить("ОблачнаяПодпись", Ложь);
	Результат.Вставить("МенятьПинКод", Ложь);
	
	Если ЗначениеЗаполнено(ТекущаяПрограмма) 
		И ТипЗнч(ТекущаяПрограмма) = ЭлектроннаяПодписьСлужебный.ТипПрограммыСервисаПодписи() Тогда
		МодульСервисКриптографииDSSСлужебныйВызовСервера = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSСлужебныйВызовСервера");
		ДанныеУчетнойЗаписи = МодульСервисКриптографииDSSСлужебныйВызовСервера.ПолучитьНастройкиПользователя(ТекущаяПрограмма);
		Результат.ОблачнаяПодпись = Истина;
		Результат.МенятьПинКод = ДанныеУчетнойЗаписи.Политика.РежимПинКода <> "Запрещено";
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	

&НаСервереБезКонтекста
Функция ЗаполнитьСписокПрограмм(Знач ВыбраннаяПрограмма)

	ИспользоватьЭлектроннуюПодписьВМоделиСервиса = ЭлектроннаяПодписьСлужебный.ИспользоватьЭлектроннуюПодписьВМоделиСервиса();	
	ДобавитьКартинку = ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() ИЛИ ИспользоватьЭлектроннуюПодписьВМоделиСервиса;
	КартинкаКомпьютера = Новый Картинка;
	КартинкаСервиса = Новый Картинка;
	КартинкаОблака = Новый Картинка;
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSS = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSS");
		КартинкаКомпьютера = МодульСервисКриптографииDSS.ПолучитьКартинкуПодсистемы("КомпьютерКлиент");
		КартинкаСервиса = МодульСервисКриптографииDSS.ПолучитьКартинкуПодсистемы("ПодписьСервиса");
		КартинкаОблака = МодульСервисКриптографииDSS.ПолучитьКартинкуПодсистемы("ПодписьОблако");
	КонецЕсли;
	
	Результат = Новый СписокЗначений;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ПрограммыЭлектроннойПодписиИШифрования.Ссылка КАК Ссылка,
	|	ПрограммыЭлектроннойПодписиИШифрования.ЭтоВстроенныйКриптопровайдер КАК ЭтоВстроенныйКриптопровайдер,
	|	ПрограммыЭлектроннойПодписиИШифрования.ТипПрограммы КАК ТипПрограммы,
	|	ЛОЖЬ КАК ОблачнаяПодпись
	|ИЗ
	|	Справочник.ПрограммыЭлектроннойПодписиИШифрования КАК ПрограммыЭлектроннойПодписиИШифрования";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Если НЕ ИспользоватьЭлектроннуюПодписьВМоделиСервиса И Выборка.ЭтоВстроенныйКриптопровайдер Тогда
			Продолжить;
		КонецЕсли;
		НоваяСтрока = Результат.Добавить(Выборка.Ссылка);
		Если Выборка.ЭтоВстроенныйКриптопровайдер И ДобавитьКартинку Тогда
			НоваяСтрока.Картинка = КартинкаСервиса;
		ИначеЕсли ДобавитьКартинку Тогда
			НоваяСтрока.Картинка = КартинкаКомпьютера;
		КонецЕсли;	
	КонецЦикла;
	
	Если ЭлектроннаяПодписьСлужебный.ИспользоватьСервисОблачнойПодписи() Тогда
		МодульСервисКриптографииDSSСлужебный = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSSСлужебный");
		МодульСервисКриптографииDSS = ОбщегоНазначения.ОбщийМодуль("СервисКриптографииDSS");
		МассивУчетныхЗаписей = МодульСервисКриптографииDSSСлужебный.ПолучитьВсеУчетныеЗаписи();
		
		Для каждого СтрокаМассива Из МассивУчетныхЗаписей Цикл
			НоваяСтрока = Результат.Добавить(СтрокаМассива.Ссылка);
			Если ДобавитьКартинку Тогда
				НоваяСтрока.Картинка = КартинкаОблака;
			КонецЕсли;	
		КонецЦикла;
			
	КонецЕсли;	
	
	Если Результат.НайтиПоЗначению(ВыбраннаяПрограмма) = Неопределено Тогда
		ПредставлениеПрограммы = ?(ЗначениеЗаполнено(ВыбраннаяПрограмма),
								СокрЛ(ВыбраннаяПрограмма),
								НСтр("ru = 'Не выбрана'"));
		Результат.Добавить(ВыбраннаяПрограмма, ПредставлениеПрограммы);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура РедактироватьИмяИОтчествоПродолжение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		
		Объект.Имя = РезультатЗакрытия.Имя;
		Объект.Отчество = РезультатЗакрытия.Отчество;
		Модифицированность = Истина;
		
	КонецЕсли;
	
КонецПроцедуры


#КонецОбласти

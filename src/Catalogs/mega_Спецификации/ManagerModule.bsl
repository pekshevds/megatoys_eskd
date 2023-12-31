#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьРесурсыСпецификации(Спецификация, Количество = 1)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТехнологическиеОперации.Номенклатура КАК Номенклатура,
		|	ТехнологическиеОперации.Количество / ТехнологическиеОперации.Ссылка.Количество * &Количество КАК Количество,
		|	ТехнологическиеОперации.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ТехнологическиеОперации.Номенклатура.ПроизводственныйРесурс КАК ПроизводственныйРесурс
		|ИЗ
		|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК ТехнологическиеОперации
		|ГДЕ
		|	ТехнологическиеОперации.Ссылка = &Спецификация";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("Количество", Количество);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;	
КонецФункции

Функция ПолучитьМатериалыСпецификации(Спецификация, Количество = 1) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Материалы.Номенклатура,
		|	Материалы.Количество / Материалы.Ссылка.Количество * &Количество КАК Количество,
		|	Материалы.ЕдиницаИзмерения,
		|	Материалы.СтадияОбработки,
		|	Материалы.СтадияОбработки КАК ВидСтадииОбработки,
		|	Материалы.Спецификация,
		|	Материалы.КлючСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.Материалы КАК Материалы
		|ГДЕ
		|	Материалы.Ссылка = &Спецификация";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("Количество", Количество);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;		
КонецФункции

Функция ПолучитьСопутствующийВыпускСпецификации(Спецификация, Количество = 1) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СопутствующийВыпуск.Номенклатура,
		|	СопутствующийВыпуск.Количество / СопутствующийВыпуск.Ссылка.Количество * &Количество КАК Количество,
		|	СопутствующийВыпуск.ЕдиницаИзмерения,		
		|	СопутствующийВыпуск.ВидСтадииОбработки КАК ВидСтадииОбработки,
		|	СопутствующийВыпуск.КлючСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.СопутствующийВыпуск КАК СопутствующийВыпуск
		|ГДЕ
		|	СопутствующийВыпуск.Ссылка = &Спецификация";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("Количество", Количество);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;		
КонецФункции

Функция ПолучитьСопутствующийВыпускСпецификацииПоКлючуСвязи(Спецификация, КлючСвязи, Количество = 1) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	СопутствующийВыпуск.Номенклатура,
		|	СопутствующийВыпуск.Количество / СопутствующийВыпуск.Ссылка.Количество * &Количество КАК Количество,
		|	СопутствующийВыпуск.ЕдиницаИзмерения,		
		|	СопутствующийВыпуск.ВидСтадииОбработки КАК ВидСтадииОбработки,
		|	СопутствующийВыпуск.КлючСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.СопутствующийВыпуск КАК СопутствующийВыпуск
		|ГДЕ
		|	СопутствующийВыпуск.Ссылка = &Спецификация И СопутствующийВыпуск.КлючСвязи = &КлючСвязи";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("КлючСвязи", КлючСвязи);
	Запрос.УстановитьПараметр("Количество", Количество);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;		
КонецФункции

Функция ПолучитьМатериалыСпецификацииПоКлючуСвязи(Спецификация, КлючСвязи, Количество = 1) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Материалы.Номенклатура,
		|	Материалы.Количество / Материалы.Ссылка.Количество * &Количество КАК Количество,
		|	Материалы.ЕдиницаИзмерения,
		|	Материалы.СтадияОбработки,
		|	Материалы.СтадияОбработки КАК ВидСтадииОбработки,
		|	Материалы.Спецификация,
		|	Материалы.КлючСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.Материалы КАК Материалы
		|ГДЕ
		|	Материалы.Ссылка = &Спецификация И Материалы.КлючСвязи = &КлючСвязи";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("КлючСвязи", КлючСвязи);
	Запрос.УстановитьПараметр("Количество", Количество);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;		
КонецФункции

Функция ПолучитьТехнологическиеОперацииСпецификацииПоКлючуСвязи(Спецификация, КлючСвязи, Количество = 1) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТехнологическиеОперации.Номенклатура,
		|	ТехнологическиеОперации.Количество / ТехнологическиеОперации.Ссылка.Количество * &Количество КАК Количество,
		|	ТехнологическиеОперации.ЕдиницаИзмерения,
		|	ТехнологическиеОперации.КлючСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК ТехнологическиеОперации
		|ГДЕ
		|	ТехнологическиеОперации.Ссылка = &Спецификация И ТехнологическиеОперации.КлючСвязи = &КлючСвязи";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("КлючСвязи", КлючСвязи);
	Запрос.УстановитьПараметр("Количество", Количество);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;		
КонецФункции

Функция ПолучитьМатериалыВидаСтадииОбработкиСпецификации(Спецификация, ВидСтадииОбработки, Количество) Экспорт
	
	СтадияОбработки = ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(Спецификация, ВидСтадииОбработки);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Материалы.Номенклатура,
		|	Материалы.Количество / Материалы.Ссылка.Количество * &Количество КАК Количество,
		|	Материалы.ЕдиницаИзмерения,
		|	Материалы.СтадияОбработки,
		|	Материалы.СтадияОбработки КАК ВидСтадииОбработки,
		|	Материалы.Спецификация,
		|	Материалы.КлючСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.Материалы КАК Материалы
		|ГДЕ
		|	Материалы.Ссылка = &Спецификация
		|	И Материалы.КлючСвязи = &КлючСвязи";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("КлючСвязи", СтадияОбработки.КлючСвязи);
	Запрос.УстановитьПараметр("Количество", Количество);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Возврат ВыборкаДетальныеЗаписи;		
КонецФункции

Функция ПолучитьПервуюНеПомеченнуюНаУдалениеСпецификацию(Номенклатура)Экспорт 
	Спецификация = ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	mega_Спецификации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.mega_Спецификации КАК mega_Спецификации
	|ГДЕ
	|	mega_Спецификации.Владелец = &Номенклатура
	|	И НЕ mega_Спецификации.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
		
	Если Выборка.Следующий() Тогда 
		
		Спецификация = Выборка.Ссылка;		
	КонецЕсли;                                
	
	Возврат Спецификация;
КонецФункции

// Получить основную спецификацию номенклатуры.
// 
// Параметры:
//  Номенклатура - СправочникСсылка.mega_Номенклатура - Номенклатура, основную спецификацию которой нужно получить
// 
// Возвращаемое значение:
//  СправочникСсылка.mega_Спецификации - СправочникСсылка.mega_Спецификации
Функция ПолучитьОсновнуюСпецификациюНоменклатуры(Номенклатура)Экспорт 
	
	ОсновнаяСпецификация = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "Спецификация");
	Если ЗначениеЗаполнено(ОсновнаяСпецификация) Тогда 
		
		Возврат ОсновнаяСпецификация;
	КонецЕсли;
	
	Возврат ПолучитьПервуюНеПомеченнуюНаУдалениеСпецификацию(Номенклатура);
КонецФункции

Функция ПолучитьПервуюСтадиюОбработки(Спецификация)Экспорт	
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	
	Если Спецификация.СтадииОбработки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;	
	
	ПерваяСтрока = Спецификация.СтадииОбработки[0];
	ЗаполнитьЗначенияСвойств(Структура, ПерваяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьПоследнююСтадиюОбработки(Спецификация)Экспорт
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	СтадииОбработки = СтадииОбработкиСпецификации(Спецификация);
	
	Если СтадииОбработки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;	
	
	ПоследняяСтрока = СтадииОбработки[СтадииОбработки.Количество() - 1];
	ЗаполнитьЗначенияСвойств(Структура, ПоследняяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(Спецификация, ВидСтадииОбработки)Экспорт
	
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	
	СтадииОбработки = СтадииОбработкиСпецификации(Спецификация);
	Если СтадииОбработки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
	
	Строки = СтадииОбработки.НайтиСтроки(Новый Структура("ВидСтадииОбработки", ВидСтадииОбработки));
	Если Строки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
	
	НайденнаяСтрока = Строки[0];
	ЗаполнитьЗначенияСвойств(Структура, НайденнаяСтрока);
	Возврат Структура;
КонецФункции


// Получить предыдущую стадию обработки.
// 
// Параметры:
//  Спецификация - СправочникСсылка.mega_Спецификации
//  ТекущаяСтадияОбработки - Структура - Текущая стадия обработки:
// * НомерСтроки - Число -
// * ВидСтадииОбработки - СправочникСсылка.mega_ВидыСтадийОбработки -
// * КлючСвязи - УникальныйИдентификатор -
// 
// Возвращаемое значение:
//  Структура - Получить предыдущую стадию обработки:
// * НомерСтроки - Число -
// * ВидСтадииОбработки - СправочникСсылка.mega_ВидыСтадийОбработки -
// * КлючСвязи - УникальныйИдентификатор -
Функция ПолучитьПредыдущуюСтадиюОбработки(Спецификация, ТекущаяСтадияОбработки)Экспорт
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	
	СтадииОбработки = СтадииОбработкиСпецификации(Спецификация);
	Если СтадииОбработки.Количество() = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
	
	Если ТекущаяСтадияОбработки.НомерСтроки <= 1 Тогда 
		
		Возврат Структура;
	КонецЕсли;
		
	ПредыдущаяСтрока = СтадииОбработки[(ТекущаяСтадияОбработки.НомерСтроки - 1) - 1];
	ЗаполнитьЗначенияСвойств(Структура, ПредыдущаяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьСледующуюСтадиюОбработки(Спецификация, ТекущаяСтадияОбработки)Экспорт
	Структура = ПолучитьСтруктуруВозвратаСтадииОбработки();
	
	СтадииОбработки = СтадииОбработкиСпецификации(Спецификация);;
	КоличествоСтадийОбработки = СтадииОбработки.Количество();
		
	Если КоличествоСтадийОбработки = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
	
	Если ТекущаяСтадияОбработки.НомерСтроки = КоличествоСтадийОбработки ИЛИ 
		ТекущаяСтадияОбработки.НомерСтроки = 0 Тогда 
		
		Возврат Структура;
	КонецЕсли;
		
	СледующаяСтрока = СтадииОбработки[ТекущаяСтадияОбработки.НомерСтроки];
	ЗаполнитьЗначенияСвойств(Структура, СледующаяСтрока);
	Возврат Структура;
КонецФункции

Функция ПолучитьВремяПроизводстваЕдиницыСпецификации(Спецификация, Количество = 1)Экспорт
	Время = 0;
	
	Для Каждого ТекСтрокаТехнологическиеОперации Из Спецификация.ТехнологическиеОперации Цикл 
		
		Время = Время + (ТекСтрокаТехнологическиеОперации.ВремяВыполнения / Спецификация.Количество * Количество);
	КонецЦикла;
	
	Возврат Время;
КонецФункции

Функция ПолучитьДоступныеВидыСтадийОбработки(Спецификация)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	mega_СпецификацииСтадииОбработки.ВидСтадииОбработки
		|ИЗ
		|	Справочник.mega_Спецификации.СтадииОбработки КАК mega_СпецификацииСтадииОбработки
		|ГДЕ
		|	mega_СпецификацииСтадииОбработки.Ссылка = &Спецификация";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ВидСтадииОбработки");
КонецФункции

Функция ПолучитьДоступныеВидыСтадийОбработкиПоПроизводственномуРесурсу(Спецификация, ПроизводственныйРесурс)Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	mega_СпецификацииТехнологическиеОперации.КлючСвязи
		|ПОМЕСТИТЬ втКлючиСвязи
		|ИЗ
		|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК mega_СпецификацииТехнологическиеОперации
		|ГДЕ
		|	mega_СпецификацииТехнологическиеОперации.Ссылка = &Спецификация
		|	И mega_СпецификацииТехнологическиеОперации.Номенклатура.ПроизводственныйРесурс = &ПроизводственныйРесурс
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	mega_СпецификацииСтадииОбработки.ВидСтадииОбработки
		|ИЗ
		|	Справочник.mega_Спецификации.СтадииОбработки КАК mega_СпецификацииСтадииОбработки
		|ГДЕ
		|	mega_СпецификацииСтадииОбработки.КлючСвязи В
		|		(ВЫБРАТЬ
		|			втКлючиСвязи.КлючСвязи
		|		ИЗ
		|			втКлючиСвязи КАК втКлючиСвязи)
		|	И mega_СпецификацииСтадииОбработки.Ссылка = &Спецификация";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("ПроизводственныйРесурс", ПроизводственныйРесурс);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ВидСтадииОбработки");
КонецФункции


// Получить технологические операции спецификации по виду стадии обработки.
// 
// Параметры:
//  Спецификация - СправочникСсылка.mega_Спецификации - Спецификация
//  ВидСтадииОбработки - СправочникСсылка.mega_ВидыСтадийОбработки - Вид стадии обработки
//  Количество - Число - Количество
// 
// Возвращаемое значение:
//  Неопределено, ВыборкаИзРезультатаЗапроса - Получить технологические операции спецификации по виду стадии обработки
Функция ПолучитьТехнологическиеОперацииСпецификацииПоВидуСтадииОбработки(Спецификация, ВидСтадииОбработки, Количество = 1)Экспорт
	
	СтадияОбработки = ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(Спецификация, ВидСтадииОбработки);
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	mega_СпецификацииТехнологическиеОперации.Номенклатура,
		|	mega_СпецификацииТехнологическиеОперации.Количество / mega_СпецификацииТехнологическиеОперации.Ссылка.Количество *
		|		&Количество КАК Количество
		|ИЗ
		|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК mega_СпецификацииТехнологическиеОперации
		|ГДЕ
		|	mega_СпецификацииТехнологическиеОперации.Ссылка = &Спецификация
		|	И mega_СпецификацииТехнологическиеОперации.КлючСвязи = &КлючСвязи";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("КлючСвязи", СтадияОбработки.КлючСвязи);
	Запрос.УстановитьПараметр("Количество", Количество);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();	
КонецФункции


// Получить доступные технологические операции.
// 
// Параметры:
//  Спецификация - СправочникСсылка.mega_Спецификации - Спецификация
//  ВидСтадииОбработки - СправочникСсылка.mega_ВидыСтадийОбработки - Вид стадии обработки
// 
// Возвращаемое значение:
//  Массив Из СправочникСсылка.mega_Номенклатура
Функция ПолучитьДоступныеТехнологическиеОперации(Спецификация, ВидСтадииОбработки = Неопределено)Экспорт
	
	Если Спецификация.СтадииОбработки.Количество() = 0 Тогда
		
		Возврат Новый Массив;
	КонецЕсли;
	
	Если ВидСтадииОбработки = Неопределено Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	mega_СпецификацииТехнологическиеОперации.Номенклатура
			|ИЗ
			|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК mega_СпецификацииТехнологическиеОперации
			|ГДЕ
			|	mega_СпецификацииТехнологическиеОперации.Ссылка = &Спецификация";
		
		Запрос.УстановитьПараметр("Спецификация", Спецификация);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номенклатура");
	КонецЕсли;
	
	СтадияОбработки = ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(Спецификация, ВидСтадииОбработки);
	Запрос = Новый Запрос;
	
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	mega_СпецификацииТехнологическиеОперации.Номенклатура
		|ИЗ
		|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК mega_СпецификацииТехнологическиеОперации
		|ГДЕ
		|	mega_СпецификацииТехнологическиеОперации.Ссылка = &Спецификация
		|	И mega_СпецификацииТехнологическиеОперации.КлючСвязи = &КлючСвязи";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	Запрос.УстановитьПараметр("КлючСвязи", СтадияОбработки.КлючСвязи);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Номенклатура");	
КонецФункции

Функция ПолучитьДлительностьТехнологическойОперации(Спецификация, ВидСтадииОбработки, ТехнологическаяОперация)Экспорт
    
    Запрос = Новый Запрос;
    Запрос.Текст =
    	"ВЫБРАТЬ
    	|	ТехнологическиеОперации.Количество / ТехнологическиеОперации.Ссылка.Количество КАК Время
    	|ИЗ
    	|	Справочник.mega_Спецификации.ТехнологическиеОперации КАК ТехнологическиеОперации
    	|ГДЕ
    	|	ТехнологическиеОперации.КлючСвязи В
    	|		(ВЫБРАТЬ
    	|			СтадииОбработки.КлючСвязи
    	|		ИЗ
    	|			Справочник.mega_Спецификации.СтадииОбработки КАК СтадииОбработки
    	|		ГДЕ
    	|			СтадииОбработки.Ссылка = &Спецификация
    	|			И СтадииОбработки.ВидСтадииОбработки = &ВидСтадииОбработки)
    	|	И ТехнологическиеОперации.Номенклатура = &ТехнологическаяОперация";
    
    Запрос.УстановитьПараметр("Спецификация", Спецификация);
    Запрос.УстановитьПараметр("ТехнологическаяОперация", ТехнологическаяОперация);
    Запрос.УстановитьПараметр("ВидСтадииОбработки", ВидСтадииОбработки);
    
    РезультатЗапроса = Запрос.Выполнить();
    
    ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
    
    Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
    	Возврат ВыборкаДетальныеЗаписи.Время;
    КонецЦикла;
    
	Возврат 0;    
КонецФункции

Функция ПолучитьСтадииОбработкиСпецификации(Спецификация) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	mega_СпецификацииСтадииОбработки.НомерСтроки КАК НомерСтроки,
		|	mega_СпецификацииСтадииОбработки.ВидСтадииОбработки,
		|	mega_СпецификацииСтадииОбработки.КлючСвязи,
		|	mega_СпецификацииСтадииОбработки.Количество
		|ИЗ
		|	Справочник.mega_Спецификации.СтадииОбработки КАК mega_СпецификацииСтадииОбработки
		|ГДЕ
		|	mega_СпецификацииСтадииОбработки.Ссылка = &Спецификация
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Возврат ВыборкаДетальныеЗаписи;	
КонецФункции

Функция ПолучитьПредыдущиеСтадииОбработки(Знач Спецификация, Знач ВидСтадииОбработки) Экспорт
	
	ПредыдущиеСтадииОбработки = Новый Массив;
	
	ТекущаяСтадияОбработки = ПолучитьСтадиюОбработкиПоВидуСтадииОбработки(Спецификация, ВидСтадииОбработки);
	ПредыдущаяСтадияОбработки = ПолучитьПредыдущуюСтадиюОбработки(Спецификация, ТекущаяСтадияОбработки);
	Пока НЕ ЭтоПустаяСтадияОбработки(ПредыдущаяСтадияОбработки) Цикл
		ПредыдущиеСтадииОбработки.Добавить(ПредыдущаяСтадияОбработки);
		
		//@skip-check query-in-loop
		ПредыдущаяСтадияОбработки = ПолучитьПредыдущуюСтадиюОбработки(Спецификация, ПредыдущаяСтадияОбработки);
	КонецЦикла;
	Возврат ПредыдущиеСтадииОбработки;
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЭтоПустаяСтадияОбработки(СтадияОбработки)
	Болванка = ПолучитьСтруктуруВозвратаСтадииОбработки();
	Возврат СтадияОбработки.КлючСвязи = Болванка.КлючСвязи; 	
КонецФункции

Функция ПолучитьСтруктуруВозвратаСтадииОбработки()
	
	Структура = Новый Структура;
	Структура.Вставить("НомерСтроки", 0);
	Структура.Вставить("ВидСтадииОбработки", Справочники.mega_ВидыСтадийОбработки.ПустаяСсылка());
	Структура.Вставить("КлючСвязи", Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"));
	
	Возврат Структура;
КонецФункции

Функция СтадииОбработкиСпецификации(Спецификация)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	mega_СпецификацииСтадииОбработки.НомерСтроки,
		|	mega_СпецификацииСтадииОбработки.ВидСтадииОбработки,
		|	mega_СпецификацииСтадииОбработки.КлючСвязи,
		|	mega_СпецификацииСтадииОбработки.Количество
		|ИЗ
		|	Справочник.mega_Спецификации.СтадииОбработки КАК mega_СпецификацииСтадииОбработки
		|ГДЕ
		|	mega_СпецификацииСтадииОбработки.Ссылка = &Спецификация";
	
	Запрос.УстановитьПараметр("Спецификация", Спецификация);
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат РезультатЗапроса.Выгрузить();
КонецФункции

#КонецОбласти



#КонецЕсли
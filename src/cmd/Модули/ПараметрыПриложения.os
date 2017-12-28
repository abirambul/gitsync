#Использовать logos
#Использовать tempfiles

Перем ЛогПриложения;
Перем ОбщиеПараметры;

Процедура Инициализация()
	ОбщиеПараметры = Новый Структура("Плагины, ВерсияПлатформы, ВыводДополнительнойИнформации, ДоменПочты", Новый Массив, "8.3", Ложь, "localhost");
КонецПроцедуры

Процедура УстановитьВерсиюПлатформы(ВерсияПлатформы) Экспорт
	ОбщиеПараметры.Вставить("ВерсияПлатформы", ВерсияПлатформы);
КонецПроцедуры

Процедура УстановитьПлагины(Знач Плагины) Экспорт
	
	ОбщиеПараметры.МенеджерПлагинов.УстановитьАктивныеПлагины(Плагины);

КонецПроцедуры

Процедура УстановитьРежимВыводаДополнительнойИнформации(Знач ВыводДополнительнойИнформации) Экспорт
	ОбщиеПараметры.Вставить("ВыводДополнительнойИнформации", ВыводДополнительнойИнформации);
КонецПроцедуры

Процедура УстановитьДоменПочты(Знач ДоменПочты) Экспорт
	ОбщиеПараметры.Вставить("ДоменПочты", ДоменПочты);
КонецПроцедуры

Процедура ПодготовитьПлагины(Знач Приложение) Экспорт
	
	МенеджерПлагинов = Новый МенеджерПлагинов;
	МенеджерПлагинов.ЗагрузитьПлагины();

	ОсновнаяКомандаПриложения = Приложение.ПолучитьКоманду();
	ПодкомандыПриложения = ОсновнаяКомандаПриложения.ПолучитьПодкоманды();

	МенеджерПлагинов.ПриРегистрацииКомандыПриложения(ОсновнаяКомандаПриложения.ПолучитьИмяКоманды(), ОсновнаяКомандаПриложения, Неопределено);

	Для каждого Подкоманда Из ПодкомандыПриложения Цикл
		МенеджерПлагинов.ПриРегистрацииКомандыПриложения(Подкоманда.ПолучитьИмяКоманды(), Подкоманда, Неопределено);
	КонецЦикла;

	ОбщиеПараметры.Вставить("МенеджерПлагинов", МенеджерПлагинов);

КонецПроцедуры

Процедура УстановитьВременныйКаталог(Знач Каталог) Экспорт
		
	Если ЗначениеЗаполнено(Каталог) Тогда
		
		БазовыйКаталог  = Каталог;
		ФайлБазовыйКаталог = Новый Файл(БазовыйКаталог);
		Если Не (ФайлБазовыйКаталог.Существует()) Тогда
			
			СоздатьКаталог(ФайлБазовыйКаталог.ПолноеИмя);
			
		КонецЕсли;
		
		ВременныеФайлы.БазовыйКаталог = ФайлБазовыйКаталог.ПолноеИмя;
		
	КонецЕсли;

КонецПроцедуры

Функция РезультатыКоманд() Экспорт

	РезультатыКоманд = Новый Структура;
	РезультатыКоманд.Вставить("Успех", 0);
	РезультатыКоманд.Вставить("НеверныеПараметры", 5);
	РезультатыКоманд.Вставить("ОшибкаВремениВыполнения", 1);
	
	Возврат РезультатыКоманд;

КонецФункции // РезультатыКоманд

Процедура УстановитьРежимОтладкиПриНеобходимости(Знач РежимОтладки) Экспорт
	
	Если РежимОтладки Тогда
		
		ЛогПриложения.УстановитьУровень(УровниЛога.Отладка);
		
	КонецЕсли;
	
КонецПроцедуры // УстановитьРежимОтладкиПриНеобходимости

Процедура ПередВыполнениемКоманды(Знач Команда) Экспорт

	Команда.ПередВыполнениемКоманды(Команда);
	ОбщиеПараметры.МенеджерПлагинов.ПередВыполнениемКоманды(Команда);
	
	ЛогПриложения.Отладка("Выполняю получение параметров команды в плагинах");
	ОбщиеПараметры.МенеджерПлагинов.ПриПолученииПараметров(Команда.ПараметрыКоманды(), Новый Соответствие);

КонецПроцедуры

Процедура ПослеВыполненияКоманды(Знач Команда) Экспорт
	
	Команда.ПослеВыполненияКоманды(Команда);
	ОбщиеПараметры.МенеджерПлагинов.ПослеВыполненияКоманды(Команда);

КонецПроцедуры

Функция Параметры() Экспорт
	Возврат ОбщиеПараметры;
КонецФункции

Функция Лог() Экспорт
	
	Если ЛогПриложения = Неопределено Тогда
		ЛогПриложения = Логирование.ПолучитьЛог(ИмяЛогаПриложения());
		
		ВыводПоУмолчанию = Новый ВыводЛогаВКонсоль();
		
		ЛогПриложения.ДобавитьСпособВывода(ВыводПоУмолчанию, УровниЛога.Отладка);
		
	КонецЕсли;

	Возврат ЛогПриложения;

КонецФункции

Функция ИмяЛогаПриложения() Экспорт
	Возврат "oscript.app."+ИмяПриложения();
КонецФункции

Функция ИмяПриложения() Экспорт

	Возврат "gitsync";
		
КонецФункции

Функция Версия() Экспорт
	
	Возврат "3.0.0-beta";
			
КонецФункции


Инициализация();

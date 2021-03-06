&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, пэмМетрикиСервер.ПолучитьПараметрыРегламентногоЗадания());
		
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	//TODO: Вставить содержимое обработчика
	
	//test
	
КонецПроцедуры


&НаКлиенте
Процедура РасписаниеРегламентногоЗаданияНажатие(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Расписание = пэмМетрикиКлиент.ОпределитьРасписаниеРегламентногоЗаданияИнтерактивно(Расписание);
	ОбновитьСостояниеФормы();

КонецПроцедуры

&НаСервере
Процедура ВыполнитьПервоначальноеЗаполнениеНаСервере()
	
	ОписаниеМетрики = Справочники.пэмМетрики.pde_metric_scrape_duration_millisecond.ПолучитьОбъект();
	ОписаниеМетрики.Наименование = "Длительность расчета метрик (миллисекунд)";
	ОписаниеМетрики.ТипМетрики = Перечисления.пэмТипыМетрик.Gauge;
	ОписаниеМетрики.МетодПолученияМетрики = Перечисления.пэмМетодыПолученияМетрик.Pull;
	ОписаниеМетрики.Активность = Истина;
	ОписаниеМетрики.Алгоритм = "
	|ТаблицаЗначений = Новый ТаблицаЗначений;                             
	|ТаблицаЗначений.Колонки.Добавить(""label"", Новый ОписаниеТипов(""Строка""));
	|ТаблицаЗначений.Колонки.Добавить(""value"", Новый ОписаниеТипов(""Число""));	
	|
	|Запрос = Новый Запрос;
	|Запрос.Текст = 
	|""ВЫБРАТЬ
	||	пэмСостояниеМетрик.Метрика.Код КАК label,
	||	пэмСостояниеМетрик.Длительность КАК value
	||ИЗ
	||	РегистрСведений.пэмСостояниеМетрик КАК пэмСостояниеМетрик"";
	|Результат = Запрос.Выполнить();
	|
	|Если НЕ Результат.Пустой() Тогда
	|	ТаблицаЗначений = Результат.Выгрузить();
	|КонецЕсли;
	|";
	ОписаниеМетрики.Записать();
	
	ОписаниеМетрики = Справочники.пэмМетрики.pde_last_refresh_second.ПолучитьОбъект();
	ОписаниеМетрики.Наименование = "Последнее обновление метрик (секунд)";
	ОписаниеМетрики.ТипМетрики = Перечисления.пэмТипыМетрик.Counter;
	ОписаниеМетрики.МетодПолученияМетрики = Перечисления.пэмМетодыПолученияМетрик.Pull;
	ОписаниеМетрики.Активность = Истина;
	ОписаниеМетрики.Алгоритм = "
	|ТаблицаЗначений = Новый ТаблицаЗначений;
	|ТаблицаЗначений.Колонки.Добавить(""label"", Новый ОписаниеТипов(""Строка""));
	|ТаблицаЗначений.Колонки.Добавить(""value"", Новый ОписаниеТипов(""Число""));	
	|
	|Запрос = Новый Запрос;
	|Запрос.Текст = 
	|""ВЫБРАТЬ
	||	пэмСостояниеМетрик.Метрика.Код КАК label,
	||	РАЗНОСТЬДАТ(пэмСостояниеМетрик.ДатаРасчета, &ТекущаяДата, СЕКУНДА) КАК value
	||ИЗ
	||	РегистрСведений.пэмСостояниеМетрик КАК пэмСостояниеМетрик"";
	|Запрос.УстановитьПараметр(""ТекущаяДата"",ТекущаяДата());
	|Результат = Запрос.Выполнить();
	|
	|Если НЕ Результат.Пустой() Тогда
	|	ТаблицаЗначений = Результат.Выгрузить();
	|КонецЕсли;
	|";	
	ОписаниеМетрики.Записать();
		
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПервоначальноеЗаполнение(Команда)
	
	ВыполнитьПервоначальноеЗаполнениеНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСостояниеФормы()
	
	Элементы.ГруппаPushgatewayСервер.Доступность = Константы.пэмИспользоватьPushgateway;
	ПредставлениеРасписания = пэмМетрикиКлиент.ПолучитьПредставлениеРасписания(Расписание, Использование);
			
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ОбновитьСостояниеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ Константы.пэмИспользоватьPushgateway Тогда
		Индекс = ПроверяемыеРеквизиты.Найти("Константы");
		ПроверяемыеРеквизиты.Удалить(Индекс);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьПриИзменении(Элемент)
	
	ОбновитьСостояниеФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура пэмИспользоватьPushgatewayПриИзменении(Элемент)
	
	Если Константы.пэмИспользоватьPushgateway Тогда
		Константы.пэмПутьНаСервереPushgateway = "/metrics/job/pushgateway/instance/product";
		Константы.пэмАдресСервераPushgateway = "";
		Константы.пэмПортСервераPushgateway = 9091;
	Иначе
		Константы.пэмПутьНаСервереPushgateway = "";
		Константы.пэмАдресСервераPushgateway = "";
		Константы.пэмПортСервераPushgateway = 0;
		Использование = Ложь;
	КонецЕсли;
	
	ОбновитьСостояниеФормы();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	сткПараметрыРегламентногоЗадания = пэмМетрикиСервер.ПолучитьПараметрыРегламентногоЗадания();
	ЗаполнитьЗначенияСвойств(сткПараметрыРегламентногоЗадания, ЭтаФорма);
	пэмМетрикиСервер.ПереопределитьРегламентноеЗадание(сткПараметрыРегламентногоЗадания);
		
КонецПроцедуры

import { TestBed } from '@angular/core/testing';

import { CarteEventService } from './carte-event.service';

describe('CarteEventService', () => {
  let service: CarteEventService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(CarteEventService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});

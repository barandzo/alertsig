import { TestBed } from '@angular/core/testing';

import { TypeIncidentService } from './type-incident.service';

describe('TypeIncidentService', () => {
  let service: TypeIncidentService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TypeIncidentService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});

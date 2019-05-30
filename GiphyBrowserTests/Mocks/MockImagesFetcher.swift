//
//  MockImagesFetcher.swift
//  GiphyBrowserTests
//
//  Created by Artem Shuba on 30/05/2019.
//

import Foundation
@testable import GiphyBrowser

class MockImagesFetcher : ImagesFetcher {
    var images: [GifImage]?
    
    func fetch(limit: Int, offset: Int, complete: @escaping (Result<ImagesResponse, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            sleep(1)
            
            guard let images = self.images?.dropFirst(offset).prefix(limit) else {
                complete(.failure(ImagesFetcherError.noData))
                return
            }

            complete(.success(ImagesResponse(data: Array(images))))
        }
    }
    
    func fetch(image: GifImage, type: ImageFetchType, complete: @escaping (Result<Data, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            sleep(1)

            guard let data = Data(base64Encoded: "iVBORw0KGgoAAAANSUhEUgAAACgAAAAoCAYAAACM/rhtAAABYWlDQ1BrQ0dDb2xvclNwYWNlRGlzcGxheVAzAAAokWNgYFJJLCjIYWFgYMjNKykKcndSiIiMUmB/yMAOhLwMYgwKicnFBY4BAT5AJQwwGhV8u8bACKIv64LMOiU1tUm1XsDXYqbw1YuvRJsw1aMArpTU4mQg/QeIU5MLikoYGBhTgGzl8pICELsDyBYpAjoKyJ4DYqdD2BtA7CQI+whYTUiQM5B9A8hWSM5IBJrB+API1klCEk9HYkPtBQFul8zigpzESoUAYwKuJQOUpFaUgGjn/ILKosz0jBIFR2AopSp45iXr6SgYGRiaMzCAwhyi+nMgOCwZxc4gxJrvMzDY7v////9uhJjXfgaGjUCdXDsRYhoWDAyC3AwMJ3YWJBYlgoWYgZgpLY2B4dNyBgbeSAYG4QtAPdHFacZGYHlGHicGBtZ7//9/VmNgYJ/MwPB3wv//vxf9//93MVDzHQaGA3kAFSFl7jXH0fsAAARTSURBVFgJzVlLa1NBFJ6ZG6vV4qsqGhXRZusqgttaX1SIrSvdtI0KQkFdiO5URN0pgg8QBDXWB7rSULAoWvsD7EaXpkq1pKJWUeqjqcn4fXO9TZqmedzcthm4zNw7c873Ze65Z845kcJl69+3ZV3ib7IZ4kGptV9I6dfs0aSUcaF1XKNXUrz0WVZ0zY1nb91AyVKEBvc2Lh1O/TkIQru0FutBJSGl7tVaDkDRIMZx6sO9XwuxAverMA7iSZWU4jUIP6xRc66suNn1uVjcogh+PLpt3vCn0SNa6GNCc4NkJ0CjixZUd9Ve7vqRD2zoUOP8b99/N+LHNGGHQ0IKLYU8V7Ns1oXl55/+zCfLuYIEY+HNzSKVvIodqZVaXp1bXXPGf63zSyHFuebjB0JLfv0ePqGlbgfwkFBWeyDy/FGutc6zvARjbQ3HRSp1Gnv2eJbPOuzWjhwwp6f9jv5NXoIt7BBKnQzc6j7rzGX3OQm+C4fnJFP9EbyS3Vhwtq7jxUm8Vmyidw26ZV/rptNQehy6H1hqTXhtJPInG0FlP+A9ycHGmmDYewK3e054TY4Y1GnrFnuIZWNyZnybQJCvlTuHZeFAR8+D8cu9v/uPESamMal8EPwgYi31KVxn8q2bijliGmx+lBltzAZtV5KIYfN76251h9y81g/7ty+m7tXXn3zNwChqaGyyrYHuK1izrCrguKCxV2z7OVHLr9UNub6WrRtGEiMDvDguilXGImISm+6MXJwpQ5AnBJ0w/ZxbV5JSoxuhvJoXxw5AKT2xyYFcyImyhiCPL54QdMKlKMxcq2b77sA87vKyx5mzxY8NB3AxnByxWGv9q1jrpnvO/Uz35EJO5KHo1e2DX0dnmlgaX0fJidyUHTLJBA/+9AJ3I33qlOLlTjotZXORoJZsorIgPqDeQlFJWnzyUextTzTW15P38J9cOj1DLuSU0mKDj8EmbHIgPV3WqK5wfFScfjvG1H6FQ9EPbz1YnNj0rTKcwE3Bg/uxnSYSnj74wkjkRG5lG3RhqPJW+HDEgKkwyU55qryVZl6DcC/uQ1SL7KsCCUqYnhZxxdQQBrnS299fvjZyMmkrVDFtDDL7Kl+tNxrIhZyYU6sqnwXHqqvs1NAbgHK12Fw0qFlRZUIcJNWIQprKVeydvGQ+9JrcjJthxg+fE2Le6h2IO03kQC7kRA2GIMsRzPiZVLtT652U4QAuhpNDkLUSliOY8TPEcQuHL28IrsFV1YGY79sa6uyqgzzn1G/GThLWSgjAjB9bjGHpzVILQ5a1cGfpkvhMgZnQ+iI5kEtOHZWYdk4gyuT5TUu9RsjN5H1aGrEMJmtBWS3nq0ROcJ/lCKyd8urC/42IwM1FAx0vUAYZ38ZsMPMxCzkUQBBxnxm/W5vM1Jk9pk5bt8BmyKiNmb0KMxMfpZ9UbPktTVGIii5gOkQrugTskGRfsUX0TJLOmCdOMX9DYH0vIya3NZ9//09fD29XTlUAAAAASUVORK5CYII=") else {
                complete(.failure(ImagesFetcherError.noData))
                return
            }
            
            complete(.success(data))
        }
    }
}
